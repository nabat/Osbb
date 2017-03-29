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

  $self->query2("SELECT * FROM osbb_main
    WHERE uid= ? ;",
    undef,
    { INFO => 1,
      Bind => [ $attr->{UID} ] }
  );

  return $self;
}


#**********************************************************
=head2 user_add($attr) - add service to db

  Arguments:

  Returns:

  Example:

    $Osbb->user_add(\%FORM);

=cut
#**********************************************************
sub user_add {
  my $self = shift;
  my ($attr) = @_;

  $self->query_add('osbb_main', $attr);

  return $self;

}

#**********************************************************
=head2 user_change($attr) - change user info

  Arguments:

  Returns:

  Example:


=cut
#**********************************************************
sub user_change {
  my $self = shift;
  my ($attr) = @_;

  $self->changes2(
    {
      CHANGE_PARAM => 'UID',
      TABLE        => 'osbb_main',
      DATA         => $attr
    }
  );

  return $self;
}

#**********************************************************
=head2 user_del($attr) - user del

  Arguments:

  Returns:

  Example:
    $Equipment->vlan_del({ID => $FORM{del}});

=cut
#**********************************************************
sub user_del {
  my $self = shift;
  my ($attr) = @_;

  $self->query_del('osbb_main', $attr);

  return $self;
}


#**********************************************************
=head2 user_list($attr) - get users list

  Arguments:


  Returns:

=cut
#**********************************************************
sub user_list {
  my $self = shift;
  my ($attr) = @_;

  delete $self->{COL_NAMES_ARR};

  $SORT      = ($attr->{SORT})      ? $attr->{SORT}      : 1;
  $DESC      = ($attr->{DESC})      ? $attr->{DESC}      : '';
  $PG        = ($attr->{PG})        ? $attr->{PG}        : 0;
  $PAGE_ROWS = ($attr->{PAGE_ROWS}) ? $attr->{PAGE_ROWS} : 25;

  my $WHERE =  $self->search_former($attr, [
      ['UID',            'INT', 'osbb.uid',                           1 ],
    ],
    { WHERE            => 1,
      USERS_FIELDS_PRE => 1,
      USE_USER_PI      => 1,
      SKIP_USERS_FIELDS=> [ 'UID' ]
    }
  );

  my $EXT_TABLE = $self->{EXT_TABLES};

  $self->query2("SELECT
      $self->{SEARCH_FIELDS}
      osbb.uid
    FROM osbb_main osbb
    INNER JOIN users u ON (u.uid=osbb.uid)
    $EXT_TABLE
    $WHERE
    ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;",
    undef,
    $attr
  );

  my $list = $self->{list};

  return $self->{list} if (defined($attr->{TOTAL}) && $attr->{TOTAL} < 1);

  $self->query2(
    "SELECT COUNT(*) AS total
     FROM osbb_main osbb
     INNER JOIN users u ON (u.uid=osbb.uid)
     $EXT_TABLE
     $WHERE",
    undef,
    { INFO => 1 }
  );

  return $list;
}


#**********************************************************
=head2 area_type_add($attr)

=cut
#**********************************************************
sub area_type_add {
  my $self = shift;
  my ($attr) = @_;

  $self->query_add('osbb_area_types', $attr);
  return [ ] if ($self->{errno});

  $admin->system_action_add("AREA TYPES: $self->{INSERT_ID}", { TYPE => 1 });
  return $self;
}

#**********************************************************
=head2 area_type_info($attr)

=cut
#**********************************************************
sub area_type_info {
  my $self = shift;
  my ($id) = @_;

  $self->query2("SELECT * FROM osbb_area_types WHERE id= ? ;",
    undef,
    { INFO => 1,
      Bind => [ $id ] }
  );

  return $self;
}

#**********************************************************
=head2 area_type_del($id)

=cut
#**********************************************************
sub area_type_del {
  my $self = shift;
  my ($id) = @_;

  $self->query_del('osbb_area_types', { ID => $id });

  return [ ] if ($self->{errno});

  $admin->system_action_add("AREA TYPES: $id", { TYPE => 10 });

  return $self;
}

#**********************************************************
=head2 area_type_change($attr)

=cut
#**********************************************************
sub area_type_change {
  my $self = shift;
  my ($attr) = @_;

  $attr->{DISABLE}=(! defined($attr->{DISABLE})) ? 0 : 1;

  $self->changes2(
    {
      CHANGE_PARAM => 'ID',
      TABLE        => 'osbb_area_types',
      DATA         => $attr
    }
  );

  return $self;
}

#**********************************************************
=head2 area_type_list($attr)

=cut
#**********************************************************
sub area_type_list {
  my $self   = shift;
  my ($attr) = @_;

  $SORT      = ($attr->{SORT})      ? $attr->{SORT}      : 1;
  $DESC      = ($attr->{DESC})      ? $attr->{DESC}      : '';
  $PG        = ($attr->{PG})        ? $attr->{PG}        : 0;
  $PAGE_ROWS = ($attr->{PAGE_ROWS}) ? $attr->{PAGE_ROWS} : 25;

  my $WHERE =  $self->search_former($attr, [
      ['LIVING_SPACE',   'INT', 'living_space',    ],
      ['UTILITY_ROOM',   'INT', 'utility_room',    ],
      ['TOTAL_SPACE',    'INT', 'total_space',     ],
      ['DOMAIN_ID',      'INT', 'domain_id'        ]
    ],
    { WHERE => 1,
    }
  );

  $self->query2("SELECT
     name,
     living_space,
     utility_room,
     total_space,
     $self->{SEARCH_FIELDS}
     id
     FROM osbb_area_types
     $WHERE
     ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;",
    undef,
    $attr
  );

  return [ ] if ($self->{errno});

  my $list = $self->{list};

  if ($self->{TOTAL} >= 0) {
    $self->query2("SELECT COUNT(id) AS total FROM osbb_area_types $WHERE",
      undef, { INFO => 1 });
  }

  return $list;
}




#**********************************************************
=head2 area_type_add($attr)

=cut
#**********************************************************
sub spending_type_add {
  my $self = shift;
  my ($attr) = @_;

  $self->query_add('osbb_spending_types', $attr);
  return [ ] if ($self->{errno});

  $admin->system_action_add("AREA TYPES: $self->{INSERT_ID}", { TYPE => 1 });
  return $self;
}

#**********************************************************
=head2 area_type_info($attr)

=cut
#**********************************************************
sub spending_type_info {
  my $self = shift;
  my ($id) = @_;

  $self->query2("SELECT * FROM osbb_spending_types WHERE id= ? ;",
    undef,
    { INFO => 1,
      Bind => [ $id ] }
  );

  return $self;
}

#**********************************************************
=head2 area_type_del($id)

=cut
#**********************************************************
sub spending_type_del {
  my $self = shift;
  my ($id) = @_;

  $self->query_del('osbb_spending_types', { ID => $id });

  return [ ] if ($self->{errno});

  $admin->system_action_add("AREA TYPES: $id", { TYPE => 10 });

  return $self;
}

#**********************************************************
=head2 area_type_change($attr)

=cut
#**********************************************************
sub spending_type_change {
  my $self = shift;
  my ($attr) = @_;

  $attr->{DISABLE}=(! defined($attr->{DISABLE})) ? 0 : 1;

  $self->changes2(
    {
      CHANGE_PARAM => 'ID',
      TABLE        => 'osbb_spending_types',
      DATA         => $attr
    }
  );

  return $self;
}

#**********************************************************
=head2 spending_type_list($attr)

=cut
#**********************************************************
sub spending_type_list {
  my $self   = shift;
  my ($attr) = @_;

  $SORT      = ($attr->{SORT})      ? $attr->{SORT}      : 1;
  $DESC      = ($attr->{DESC})      ? $attr->{DESC}      : '';
  $PG        = ($attr->{PG})        ? $attr->{PG}        : 0;
  $PAGE_ROWS = ($attr->{PAGE_ROWS}) ? $attr->{PAGE_ROWS} : 25;

  my $WHERE =  $self->search_former($attr, [
    ],
    { WHERE => 1,
    }
  );

  $self->query2("SELECT
     name,
     comments,
     id
     FROM osbb_spending_types
     $WHERE
     ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;",
    undef,
    $attr
  );

  return [ ] if ($self->{errno});

  my $list = $self->{list};

  if ($self->{TOTAL} >= 0) {
    $self->query2("SELECT COUNT(id) AS total FROM osbb_spending_types $WHERE",
      undef, { INFO => 1 });
  }

  return $list;
}



1;