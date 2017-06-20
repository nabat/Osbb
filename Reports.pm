=head2 NAME

  OSBB Reports

=cut

use warnings;
use strict;

our (
  $db,
  $admin,
  %conf,
  %lang,
  $html,
);

#**********************************************************
=head2 osbb_start_page($attr)

=cut
#**********************************************************
sub osbb_start_page {
  my ($attr) = @_;

  my %START_PAGE_F = (
      'osbb_quick_menu'     => "$lang{OSBB} $lang{MENU}",
      'osbb_finance_report' => "$lang{OSBB} $lang{BALANCE}",
      'osbb_tarifs_report'    => "$lang{OSBB} $lang{TARIFS}",
  );

  return \%START_PAGE_F;
}

#**********************************************************
=head2 osbb_quick_menu($attr)

=cut
#**********************************************************
sub osbb_quick_menu {
  
  my $report = '';
  
  $report .= $html->button("$lang{HOUSING}",
    "index=" . get_function_index('osbb_users_list'),
     { class => 'btn btn-warning btn-block' });
     
  $report .= $html->button("$lang{TARIFS}",
    "index=" . get_function_index('osbb_tarifs'),
     { class => 'btn btn-success btn-block' });
     
  $report .= $html->button("$lang{ADD} $lang{PAYMENTS}",
    "index=" . get_function_index('osbb_payments_add'),
     { class => 'btn btn-info btn-block' });

  $report .= $html->button( $lang{MONTHLY_FEES},
    "index=" . get_function_index('osbb_month_fees'),
    { class => 'btn btn-primary btn-block' });
    
  $report .= $html->button( $lang{BALANCE},
    "index=" . get_function_index('osbb_calculated_balance'),
    { class => 'btn btn-danger btn-block' });
  
  my $box_body = $html->element('div', $report, { class => "box-body" });
  my $box_header = $html->element('div', $html->element('h3', $lang{OSBB}, { class=>'box-title'}), { class => 'box-header with-border' });

  
  return $html->element('div', $box_header . $box_body, { class => "box box-primary" });
  
}

#**********************************************************
=head2 osbb_finance_report($attr)

=cut
#**********************************************************
sub osbb_finance_report {

  my ($year, $month, undef) = split('-', $DATE);
  our @MONTHES;
  my $Extfin = Extfin->new($db, $admin, \%conf);
  my $Payments = Finance->payments($db, $admin, \%conf);
  my $Fees = Finance->fees($db, $admin, \%conf);
  my $Osbb = Osbb->new($db, $admin, \%conf);
  my $period = sprintf("%s-%#.2d", $year, $month);
  
  my $users_list = $Osbb->user_list({
    LOCATION_ID   => $FORM{LOCATION_ID},
    FIO           => '_SHOW',
    ADDRESS_FLAT  => '_SHOW',
    UID           => '_SHOW',
    BILL_ID       => '_SHOW',
    ADDRESS_FULL  => '_SHOW',
    COLS_NAME     => 1,
    PAGE_ROWS     => 10000,
    SORT          => 'pi.address_flat',
    DESC          => 1
  });
  
  my $total_old_saldo = 0;
  my $total_fees      = 0;
  my $total_payments  = 0;
  
  foreach my $user_line (@$users_list) {
    my $balance_report_info = $Extfin->extfin_report_balance_info({
      PERIOD => $period, 
      BILL_ID => $user_line->{bill_id}, 
      COLS_NAME => 1 
    });
    
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
    
    $total_old_saldo += $balance_report_info->{SUM} || 0.00;
    $total_fees      += $Fees->{SUM} || 0;
    $total_payments  += $Payments->{SUM} || 0;
  }
  
  my $end_saldo = $total_old_saldo - $total_fees + $total_payments;

  my $table = $html->table(
    {
      width      => '100%',
      caption    => "$lang{BALANCE} за $MONTHES[$month-1]",
      border     => 5,
      ID         => 'BALANCE',
      rows       => [
        [$lang{START_SALDO},   sprintf('%.2f', $total_old_saldo  )],
        [$lang{FEES},          sprintf('%.2f', $total_fees       )],
        [$lang{PAYMENTS},      sprintf('%.2f', $total_payments   )],
        [$lang{END_SALDO},     sprintf('%.2f', $end_saldo        )]
      ],
    }
  );

  return $table->show();
}

#**********************************************************
=head2 osbb_tarifs_info($attr)

=cut
#**********************************************************
sub osbb_tarifs_report{

  my $Osbb = Osbb->new($db, $admin, \%conf);

  my $table = $html->table(
    {
      width       => '100%',
      caption     => "$lang{TARIFS}",
      ID          => 'TARIFS',
    }
  ); 
  my @unit_list = ('', 'за м.кв.', 'за человека', '');
  my $tarifs_list = $Osbb->osbb_tarifs_list({ UNIT => '_SHOW', NAME => '_SHOW', PRICE => '_SHOW', COLS_NAME => 1, COLS_UPPER => 1 });
  foreach my $tarif_line (@$tarifs_list) {
    $table->addrow($tarif_line->{NAME}, $tarif_line->{PRICE}, $unit_list[$tarif_line->{UNIT}] || '');
  }
  if (@$tarifs_list < 1) {
    $table->addrow( 
      $html->button("$lang{ADD}", "index=" . get_function_index('osbb_tarifs') . "&add_form=1",
      { class => 'btn btn-success btn-block' })
    );
  }

  return $table->show();
}

1;