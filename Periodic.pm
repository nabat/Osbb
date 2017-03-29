=head1 NAME

  Periodics

=cut

use warnings;
use strict;

our (
  $db,
  $admin,
  %lang,
  $html,
  %ADMIN_REPORT
);

my $Osbb = Osbb->new($db, $admin, \%conf);
my $Fees = Fees->new($db, $admin, \%conf);

#**********************************************************
=head2 osbb_monthly_fees($attr) - Monthly fees

=cut
#**********************************************************
sub osbb_monthly_fees {
  my ($attr) = @_;

  my $debug = $attr->{DEBUG} || 0;
  my $debug_output = '';
  $debug_output .= "Osbb: Monthly periodic payments\n" if ($debug > 1);
  $ADMIN_REPORT{DATE} = $DATE if (!$ADMIN_REPORT{DATE});

  my %USERS_LIST_PARAMS = ();
  $USERS_LIST_PARAMS{LOGIN}        = $attr->{LOGIN} if ($attr->{LOGIN});
  $USERS_LIST_PARAMS{REGISTRATION} = "<$ADMIN_REPORT{DATE}";
  $USERS_LIST_PARAMS{GID}          = $attr->{GID} if ($attr->{GID});
  my $START_PERIOD_DAY = ($conf{START_PERIOD_DAY}) ? $conf{START_PERIOD_DAY} : 1;
  my $fees_methods                 = get_fees_types({ SHORT => 1 });
  my (undef, undef, $d)      = split(/-/, $ADMIN_REPORT{DATE}, 3);

  if($START_PERIOD_DAY != $d) {
    return $debug_output;
  }

  $users = Users->new($db, $admin, \%conf);
  $Osbb->{debug} = 1 if ($debug > 6);
  my $tarif_list = $Osbb->area_type_list({
    DOMAIN_ID   => '_SHOW',
    %LIST_PARAMS,
    COLS_NAME   => 1,
  });

  my @fees_areas = (
    'living_space',
    'utility_room',
    'total_space',
  );

  foreach my $tarif (@$tarif_list) {
    $debug_output .= "TP ID: $tarif->{id} Living_space: $tarif->{living_space} utility_room: $tarif->{utility_room} "
      ."total_space: $tarif->{total_space}\n" if ($debug > 1);

    my $user_list = $Osbb->user_list({
      SORT        => 1,
      PAGE_ROWS   => 1000000,
      DELETED     => 0,
      LOGIN       => '_SHOW',
      BILL_ID     => '_SHOW',
      DEPOSIT     => '_SHOW',
      CREDIT      => '_SHOW',
      PERSONAL_TP => '_SHOW',
      REDUCTION   => '_SHOW',
      LIVING_SPACE=> '_SHOW',
      UTILITY_ROOM=> '_SHOW',
      TYPE        => $tarif->{id},
      COLS_NAME   => 1,
      %USERS_LIST_PARAMS
    });

    foreach my $u (@$user_list) {

      $debug_output .= " Login: $u->{login} ($u->{uid}) LIVING_SPACE: $u->{living_space} UTILITY_ROOM: $u->{utility_room} \n" if ($debug > 3);
      for(my $area_num=0; $area_num<=$#fees_areas; $area_num++ ) {
        if($tarif->{$fees_areas[$area_num]} == 0 || $u->{$fees_areas[$area_num]} == 0) {
          next;
        }

        $debug_output .= "Fees: $fees_areas[$area_num]: $tarif->{$fees_areas[$area_num]}\n" if($debug > 3);
        my %FEES_DSC = (
          SERVICE_NAME      => 'Osbb',
          MODULE            => 'Osbb',
          TP_ID             => $tarif->{id},
          TP_NAME           => $tarif->{name},
          FEES_PERIOD_MONTH => $lang{MONTH_FEE_SHORT},
          FEES_METHOD       => $fees_methods->{$tarif->{fees_method}}
        );

        my %FEES_PARAMS = (
          DATE   => $ADMIN_REPORT{DATE},
          METHOD => ($tarif->{fees_method}) ? $tarif->{fees_method} : 1,
        );
        my $sum = $tarif->{$fees_areas[$area_num]} * $u->{$fees_areas[$area_num]};
        #take fees in first day of month
        $FEES_PARAMS{DESCRIBE} = fees_dsc_former(\%FEES_DSC);
        $Fees->take({
          UID     => $u->{uid},
          BILL_ID => $u->{bill_id}
        },
        $sum, \%FEES_PARAMS);
        if($Fees->{errno}) {
          print "$Fees->{errno} $Fees->{errstr}\n";
        }
      }
    }
  }

  $DEBUG .= $debug_output;
  return $debug_output;
}


1;
