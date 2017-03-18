=head2 NAME

  OSBB User portal

=cut

use warnings;
use strict;

our (
  $db,
  $admin,
  %conf,
  %lang,
  $html,
  %space_type
);

my $Osbb = Osbb->new($db, $admin, \%conf);

#**********************************************************
=head2 osbb_user($attr)

=cut
#**********************************************************
sub osbb_client_info {

  if ( $user->{UID} ){
    $Osbb->user_info({ UID => $user->{UID}  });

    if ( !$Osbb->{errno} ){
      $FORM{chg}=1;
      $Osbb->{APARTMENT_AREA} = sprintf("%.2f", $Osbb->{LIVING_SPACE} + $Osbb->{UTILITY_ROOM});
      $Osbb->{TYPE} = ($space_type{$Osbb->{TYPE}}) ? $space_type{$Osbb->{TYPE}} : $Osbb->{TYPE};
    }
  }

  $html->tpl_show(
    _include( 'osbb_client_info', 'Osbb' ),
    {
      %$Osbb,
    }
  );

  return 1;
}


1;