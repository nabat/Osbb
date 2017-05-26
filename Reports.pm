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

  my %START_PAGE_F = ('Osbb_wizard' => 1 );

  return \%START_PAGE_F;
}

#**********************************************************
=head2 osbb_wizard($attr)

=cut
#**********************************************************
sub osbb_wizard {

  print "Hello, World";

}

1;