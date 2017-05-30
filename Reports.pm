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
      'osbb_users_summary'  => "$lang{HOUSING}",
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
  my $period = sprintf("%s-%#.2d", $year, $month);
  
  $Extfin->extfin_report_balance_list({ PERIOD => $period });
  $Payments->list({ MONTH => $period });
  $Fees->list({ MONTH => $period });
  my $end_saldo = $Extfin->{TOTAL_SUM} - $Fees->{SUM} + $Payments->{SUM};

  my $table = $html->table(
    {
      width      => '100%',
      caption    => "$lang{BALANCE} за $MONTHES[$month-1]",
      border     => 5,
      ID         => 'BALANCE',
      rows       => [
        [$lang{START_SALDO},   sprintf('%.2f', $Extfin->{TOTAL_SUM} || 0)],
        [$lang{FEES},          sprintf('%.2f', $Fees->{SUM}         || 0)],
        [$lang{PAYMENTS},      sprintf('%.2f', $Payments->{SUM}     || 0)],
        [$lang{END_SALDO},     sprintf('%.2f', $end_saldo           || 0)]
      ],
    }
  );

  return $table->show();
}

#**********************************************************
=head2 osbb_users_summary($attr)

=cut
#**********************************************************
sub osbb_users_summary{
  #my ($attr) = @_;

  my $Extfin = Extfin->new($db, $admin, \%conf);
  my $Osbb = Osbb->new($db, $admin, \%conf);
  my $User = Users->new($db, $admin, \%conf);

  my $table = $html->table(
    {
      width       => '100%',
      caption     => "$lang{HOUSING}",
      ID          => 'USERS_SUMMARY',
      title_plain => [ $lang{ADDRESS_BUILD}, $lang{HOUSING}],
      
    }
  );

  return $table->show();
}

1;