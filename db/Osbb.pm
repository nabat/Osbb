package Osbb;
=head1 NAME

 DHCP server managment and user control

=cut

use strict;
use parent 'main';
my $MODULE = 'Osbb';
my Admins $admin;
my $CONF;
my $SORT      = 1;
my $DESC      = '';
my $PG        = 0;
my $PAGE_ROWS = 25;

#**********************************************************
# Init
#**********************************************************
sub new {
  my $class = shift;
  my $db    = shift;
  ($admin, $CONF) = @_;

  $admin->{MODULE} = $MODULE;

  my $self = {
    db    => $db,
    admin => $admin,
    conf  => $CONF
  };

  bless($self, $class);

  return $self;
}


#**********************************************************
=head2 user_info($id) - Get user info

  Arguments:
    $id
    $attr

  Returns:
    Object

=cut
#**********************************************************
sub user_info {
  my $self = shift;
  my ($attr) = @_;

#  $self->query2("SELECT * FROM equipment_models
#    WHERE id= ? ;",
#    undef,
#    { INFO => 1,
#      Bind => [ $id ] }
#  );

  return $self;
}


1;