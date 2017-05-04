#!perl
=head1 NAME


=cut

use strict;
use warnings FATAL => 'all';
use Abills::Defs;
use Abills::Base qw(time2sec);
use Finance;
use Users;
use Extfin;

our (
  $db,
  $admin,
  %conf,
  %lang,
  $html,
  @MONTHES,
  @WEEKDAYS,
  %ADMIN_REPORT,
  %permissions,
  %err_strs,
  @status
);

my $Osbb = Osbb->new($db, $admin, \%conf);
my $User = Users->new($db, $admin, \%conf);


#**********************************************************
=head2 osbb_calculated_balance () -

  Arguments:
    ATTRIBUTES -
  Returns:

  Examples:

=cut
#**********************************************************
sub osbb_calculated_balance {

  my $Payments = Finance->payments($db, $admin, \%conf);
  my $Fees = Finance->fees($db, $admin, \%conf);
  my $User  = Users->new($db, $admin, \%conf);
  my $Extfin = Extfin->new($db, $admin, \%conf);
  my $Address = Address->new($db, $admin, \%conf);
  
  my $builds_list = $Address->build_list({ COLS_NAME => 1, PAGE_ROWS => 1 });
  _error_show($Address);
    
  $FORM{LOCATION_ID} = $FORM{LOCATION_ID} || $builds_list->[0]->{id};
  my $params = ();
  my %balance_next_period = ();

  my @YEARS = ('2017', '2018', '2019', '2020', '2021', '2022', '2023');

  my ($year, $month, undef) = split('-', $DATE);

  $params->{BUTTON} = $lang{ADD};
  $params->{ACTION} = 'add';

  if ($FORM{MONTH}) {
    $month = $FORM{MONTH};
  }
  else {
    $FORM{MONTH} = int($month);
  }
  if ($FORM{YEAR}) {
    $year  = $FORM{YEAR};
  }
  else {
    $FORM{YEAR} = $year;
  }

  $params->{MONTH_SELECT} = $html->form_select(
    'MONTH',
    {
      SELECTED => $FORM{MONTH},
      SEL_ARRAY    => [ '', @MONTHES ],
      ARRAY_NUM_ID => 1,
    }
  );

  $params->{YEAR_SELECT} = $html->form_select(
    'YEAR',
    {
      SELECTED => $FORM{YEAR},
      SEL_ARRAY => [ '', @YEARS ],
    }
  );
  
  $params->{BUILD_SELECT} = osbb_simple_build_select();
  
  my $qs = "LOCATION_ID=$FORM{LOCATION_ID}&MONTH=$FORM{MONTH}&YEAR=$FORM{YEAR}";

  my $table = $html->table(
    {
      width      => '100%',
      caption    => "Оборотно-сальдова відомість за : " . ($MONTHES[ int($month - 1) ] . " $year"),
      border     => 1,
      title      => [ $lang{ADDRESS_FLAT}, $lang{FIO}, "Сальдо на початок", "Нарахування", "Оплати", "Сальдо на кінець" ],
      ID         => 'OSBB_CALCULATED_BALANCE',
      EXPORT     => 1,
      MENU       => "$lang{PRINT}:qindex=$index&header=2&print_form=1$qs:print"
    }
  );

  my $users_list = $Osbb->user_list({
    LOCATION_ID   => $FORM{LOCATION_ID},
    FIO           => '_SHOW',
    ADDRESS_FLAT  => '_SHOW',
    UID           => '_SHOW',
    BILL_ID       => '_SHOW',
    
    COLS_NAME     => 1,
    PAGE_ROWS     => 10000,
    SORT          => 'pi.address_flat',
    DESC          => 1
  });
  _error_show($Osbb);

  my $period = sprintf("%s-%#.2d", $year, $month);

  my $total_old_saldo = 0.00;
  my $total_fees      = 0.00;
  my $total_payments  = 0.00;
  my $total_new_saldo = 0.00;

  my $users_print_table = '';

  foreach my $user_line (@$users_list) {
    my $balance_report_info = $Extfin->extfin_report_balance_info({ PERIOD => $period, BILL_ID => $user_line->{bill_id}, COLS_NAME => 1 });

    my $month_payments = $Payments->list({
      MONTH     => $period,
      BILL_ID   => $user_line->{bill_id},
      COLS_NAME => 1,
    });

    my $month_fees = $Fees->list({
      MONTH     => $period,
      BILL_ID   => $user_line->{bill_id},
      COLS_NAME => 1,
    });

    my $saldo = (($balance_report_info->{SUM} || 0.00) * (-1)) + $Fees->{SUM} - $Payments->{SUM};

    my $user_button = $html->button($user_line->{fio} || "Немає ФІО", "index=15&UID=$user_line->{uid}", {});

    $table->addrow($user_line->{address_flat}, $user_button, sprintf('%.2f', (($balance_report_info->{SUM} || 0.00) * (-1))), sprintf('%.2f', $Fees->{SUM}), sprintf('%.2f', $Payments->{SUM}), sprintf('%.2f', $saldo));

    $users_print_table .=
      "<tr><td>"
    . $user_line->{address_flat}
    . "</td><td align='right'>"
    . ($user_line->{fio} || '---------')
    . "</td><td align='right'>"
    . sprintf('%.2f', ($balance_report_info->{SUM} || 0.00) * (-1))
    . "</td><td align='right'>"
    . sprintf('%.2f', $Fees->{SUM})
    . "</td><td align='right'>"
    . sprintf('%.2f', $Payments->{SUM})
    . "</td><td align='right'>"
    . sprintf('%.2f', $saldo)
    . "</td></tr>";

    # total count
    $total_old_saldo -= $balance_report_info->{SUM} || 0.00;
    $total_fees      += $Fees->{SUM};
    $total_payments  += $Payments->{SUM};
    $total_new_saldo += $saldo;
    $balance_next_period{$user_line->{bill_id}} = $saldo;
  }

  $table->addrow('-', '-', '-', '-', '-', '-');
  $table->addrow("$lang{TOTAL}", "", sprintf('%.2f', $total_old_saldo), sprintf('%.2f', $total_fees), sprintf('%.2f', $total_payments), sprintf('%.2f', $total_new_saldo));

  $users_print_table .=
    "<tr><td>$lang{TOTAL}</td><td></td><td align='right'>" 
  . sprintf('%.2f', $total_old_saldo) 
  . "</td><td align='right'>" 
  . sprintf('%.2f', $total_fees) 
  . "</td><td align='right'>" 
  . sprintf('%.2f', $total_payments) 
  . "</td><td align='right'>" 
  . sprintf('%.2f', $total_new_saldo) 
  . "</td></tr>";

  my $print_table = qq{
    <table width="100%" cellspacing="0" border="1">
  <thead>
    <tr>
      <td align='center'>$lang{ADDRESS_FLAT}</td>
      <td align='center'>$lang{FIO}</td>
      <td align='center'>Сальдо на початок</td>
      <td align='center'>Нарахування</td>
      <td align='center'>Оплати</td>
      <td align='center'>Сальдо на кінець</td>
    </tr>
  <thead>
  <tbody>
  $users_print_table
  </tbody>
  </table>
  };

  if ($FORM{print_form}) {
    $html->tpl_show(_include('osbb_balance_reports_print', 'Osbb'),
      {
        TABLE  => $print_table,
        PERIOD => ($MONTHES[ int($month - 1) ] . " $year"),
      }
    );

    return 1;
  }

  $params->{TABLE} =  $table->show();

  $html->tpl_show(_include('osbb_balance_reports', 'Osbb'), $params);

  if($FORM{add}){

    my $next_month = $FORM{MONTH} + 1;
    my $next_year  = $FORM{YEAR};

    if($next_month > 12){
      $next_year += 1;
      $next_month = 1
    }

    my $next_period = sprintf("%s-%#.2d", $next_year, $next_month);

    $Extfin->extfin_report_balance_del({PERIOD => $next_period});

    _error_show($Extfin);
    
    foreach my $bill_id ( keys %balance_next_period) {
      my $saldo = $balance_next_period{$bill_id};

      $Extfin->extfin_report_balance_add({BILL_ID => $bill_id, 
                                          SUM     => $saldo, 
                                          PERIOD  => $next_period,
                                          AID     => 1,
                                          DATE    => $DATE});
      _error_show($Extfin);
    }
  }

  return 1;
}

#**********************************************************
=head2 osbb_month_fees () -

  Arguments:
    ATTRIBUTES -
  Returns:

  Examples:

=cut
#**********************************************************
sub osbb_month_fees {
  #my ($attr) = @_;

  #my $Payments = Finance->payments($db, $admin, \%conf);
  my $Fees = Finance->fees($db, $admin, \%conf);
  my $Address = Address->new($db, $admin, \%conf);
  my $builds_list = $Address->build_list({ COLS_NAME => 1, PAGE_ROWS => 1 });
  _error_show($Address);
    
  $FORM{LOCATION_ID} = $FORM{LOCATION_ID} || $builds_list->[0]->{id};
  
  my $params = ();
  my @fees_array = ();
  
  $params->{BUTTON} = $lang{ADD};
  $params->{ACTION} = 'add';

  my @YEARS = ('2017', '2018', '2019', '2020', '2021', '2022', '2023');

  my ($year, $month, undef) = split('-', $DATE);

  if ($FORM{MONTH}) {
    $month = $FORM{MONTH};
  }
  else {
    $FORM{MONTH} = int($month);
  }
  if ($FORM{YEAR}) {
    $year  = $FORM{YEAR};
  }
  else {
    $FORM{YEAR} = $year;
  }
  
  $params->{MONTH_SELECT} = $html->form_select(
    'MONTH',
    {
      SELECTED => $FORM{MONTH},
      SEL_ARRAY    => [ '', @MONTHES ],
      ARRAY_NUM_ID => 1,
    }
  );

  $params->{YEAR_SELECT} = $html->form_select(
    'YEAR',
    {
      SELECTED => $FORM{YEAR},
      SEL_ARRAY => [ '', @YEARS ],

      # ARRAY_NUM_ID=>1,
    }
  );
  
  $params->{BUILD_SELECT} = osbb_simple_build_select();
  
  my $qs = "LOCATION_ID=$FORM{LOCATION_ID}&MONTH=$FORM{MONTH}&YEAR=$FORM{YEAR}";

  my $table = $html->table(
    {
      width      => '100%',
      caption    => "Нарахування :  " . ($MONTHES[ int($month - 1) ] . " $year"),
      border     => 1,
      title      => [ "$lang{ADDRESS_FLAT}", "$lang{FIO}", "<div class='text-center'>Нарахування (грн.)</div>"],
      ID         => 'MONTHLY_FEES',
      MENU       => "$lang{PRINT}:qindex=$index&header=2&print_form=1&$qs:print",
    }
  );

  my $period = sprintf("%s-%#.2d", $year, $month);
  my $users_list = $Osbb->user_list({
    LOCATION_ID   => $FORM{LOCATION_ID},
    FIO           => '_SHOW',
    ADDRESS_FLAT  => '_SHOW',
    UID           => '_SHOW',
    PEOPLE_COUNT  => '_SHOW',
    LIVING_AREA   => '_SHOW',
    BILL_ID       => '_SHOW',
    
    COLS_NAME     => 1,
    PAGE_ROWS     => 10000,
    SORT          => 'pi.address_flat',
    DESC          => 1
  });
  _error_show($Osbb);
  
  
  my $month_fees = $Fees->list({ 
    LOCATION_ID   => $FORM{LOCATION_ID},
    DOMAIN_ID     => $admin->{DOMAIN_ID},
    MONTH         => $period,
    COLS_NAME     => 1,
  });
  _error_show($Fees);
  
  if ($Fees->{SUM} > 0 && !$FORM{print_form}) {
    $html->message('info', "За цей період вже нараховано: " . sprintf('%.2f',$Fees->{SUM}));
    $params->{CHANGE} = $html->form_input('change', $lang{CHANGE_}, { TYPE => 'submit' });
  }
  
  my $total_fees = 0;
  my $users_print_table = '';
  
  foreach my $user_line (@$users_list) {
    
    my $total_fee = 0;
    my $tooltip = '';

    my $servises_list = $Osbb->users_services_list({
      UID           => $user_line->{uid},
      COLS_NAME     => 1,
      PAGE_ROWS     => 10000,
      SORT          => 'tp_id',
    });
        
    if (ref $servises_list eq 'ARRAY') {
      foreach my $service (@$servises_list) {
        my $fee = 0;
        my $service_info = $Osbb->osbb_tarifs_info($service->{tp_id});

        if ($service_info->{UNIT}==1) {
          $fee = $service_info->{PRICE} * $user_line->{living_area};
          $tooltip .= "$service_info->{NAME} : $user_line->{living_area} * $service_info->{PRICE} = $fee<br>";
        }
        if ($service_info->{UNIT}==2) {
          $fee = $service_info->{PRICE} * $user_line->{people_count};
          $tooltip .= "$service_info->{NAME} : $user_line->{people_count} * $service_info->{PRICE} = $fee<br>";
        }
        $total_fee += $fee;
      }

      $table->addrow($user_line->{address_flat}, $user_line->{fio}, "<div class='text-center' data-tooltip='$tooltip' data-tooltip-position='top'>$total_fee</div>");
      push (@fees_array, [$user_line->{uid}, $user_line->{bill_id}, $total_fee]);

    $users_print_table .=
        "<tr><td>" . $user_line->{address_flat}
      . "</td><td>" . $user_line->{fio}
      . "</td><td>" . sprintf('%.2f', $total_fee)
      . "</td></tr>";
    }
    $total_fees += $total_fee;
  }

  $table->addrow('-','-',"<div class='text-center'>-</div>");
  $table->addrow("Разом :", scalar( @fees_array), "<div class='text-center'>$total_fees</div>");
  
  $users_print_table .= "<tr><td>Разом</td><td></td><td>" . sprintf('%.2f', $total_fees) . "</td></tr>";
    
  my $print_table = qq{
    <table width="100%" cellspacing="0" border="1">
      <thead>
        <tr>
          <td>$lang{ADDRESS_FLAT}</td>
          <td>$lang{FIO}</td>
          <td>Нарахування</td>
        </tr>
      <thead>
  <tbody>
  $users_print_table
  </tbody>
  </table>
  };

  if ($FORM{print_form}) {
    $Address->address_info($FORM{LOCATION_ID});
    $html->tpl_show(
      _include('osbb_month_fees_print', 'Osbb'),
      {
        TABLE   => $print_table,
        PERIOD  => ($MONTHES[ int($month - 1) ] . " $year"),
        ADDRESS => $Address->{ADDRESS_STREET} . ", " . $Address->{ADDRESS_BUILD},
      }
    );

    return 1;
  }  

  $params->{TABLE} = $table->show();
  
  $html->tpl_show(_include('osbb_form_month_fees', 'Osbb'), $params);

  if ($FORM{add} || $FORM{change}) { 
    if ($FORM{change}) {
      foreach (@$month_fees) {
        $Fees->del(undef, $_->{id});
      }
    }  
    foreach ( @fees_array ) {
      $Osbb->fees_add( {UID => $_->[0], BILL_ID => $_->[1], SUM => $_->[2], DATE => $period . "-01"} );
    }
  }
  
  return 1;
}

#**********************************************************
=head2 osbb_payments_add()

=cut
#**********************************************************
sub osbb_payments_add{
  if (!defined($FORM{sub}) || $FORM{sub} eq '' ) {
    $FORM{sub} = 1;
  }
  
  my $active_button->{$FORM{sub}} = { class => 'active' };
  my %nav_tabs = (
    1 => "Pay",
    2 => "Payments",
    3 => "Import",
  );
    
  my $buttons = '';
  foreach( sort { $a <=> $b } keys(%nav_tabs) ){
    $buttons .= $html->li( $html->button( $nav_tabs{$_}, "index=$index&sub=$_" ), $active_button->{$_} )
  }
  
  print $html->element( 'div',
    $html->element( 'ul', $buttons, { class => 'nav navbar-nav' }) ,
    { class => 'navbar navbar-default' } );
  
  if($FORM{sub} == 3) {
    #TODO
    $html->message('info', "Under construction");
    return 1;
  }
  elsif($FORM{sub} == 2) {
    #TODO
    $html->message('info', "Under construction");
    return 1;
  }
  else {
    if ($FORM{add} && $FORM{SUM}){
      $FORM{SUM} =~ s/,/\./g;
      if ($FORM{SUM} !~ /[0-9\.]+/) {
        $html->message( 'err', $lang{ERROR}, "$lang{ERR_WRONG_SUM} SUM: $FORM{SUM}");
        return 0;
      }
      
      my $user_info = $User->info($FORM{UID});

      $Osbb->payments_add({ %FORM, BILL_ID => $user_info->{BILL_ID} });
      _error_show($Osbb);
      if (!$Osbb->{errno}) {
        $html->message('info', "$lang{ADDED}");
        delete $FORM{SUM};
      }
    }
    my $Address = Address->new($db, $admin, \%conf);
    my $builds_list = $Address->build_list({ COLS_NAME => 1, PAGE_ROWS => 1 });
    _error_show($Address);
    
    $FORM{LOCATION_ID} = $FORM{LOCATION_ID} || $builds_list->[0]->{id};
    my $build_sel = osbb_simple_build_select({ AUTO_SUBMIT => 1 , %FORM});
    my $users_sel = _osbb_user_select();
    my $ptype_sel = _osbb_payments_type_select();
      
    if (!$FORM{DATE}) {
      $FORM{DATE} = $DATE;
    }
      
    $html->tpl_show(_include('osbb_form_payments_add', 'Osbb'), {
            PTYPE_SEL => $ptype_sel,
            BUILD_SEL => $build_sel,
            USERS_SEL => $users_sel,
            %FORM
            });
  }
  return 1;
}


1

