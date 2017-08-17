package Osbb;

=head1 NAME

 Osbb users management

=cut

use strict;
use parent 'main';
my $MODULE = 'Osbb';

my Admins $admin;
my $CONF;

use Abills::Base qw/_bp/;

my %UNUSUAL_TABLE_NAMES = (
  'osbb_payments' => 'payments',
  'osbb_fees'     => 'fees'
);

#**********************************************************

=head2 new($db, $admin, \%conf) - constructor for Osbb DB manage module

=cut

#**********************************************************
sub new {
  my $class = shift;
  my $db = shift;
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

=head2 AUTOLOAD

  Because all namings are standart, 'add', 'change', 'del', 'info' can be generated automatically.

=head2 SYNOPSIS

  AUTOLOAD is called when undefined function was called in Package::Foo.
  global $AUTOLOAD var is filled with full name of called undefined function (Package::Foo::some_function)

  Because in this module DB tables and columns are named same as template variables, in all logic for custom operations
  the only thing that changes is table name.

  We can parse it from called function name and generate 'add', 'change', 'del', 'info' functions on the fly

=head2 USAGE

  You should use this function as usual, nothing changes in webinterface logic.
  Just call $Osbb->user_info($cable_type_id)

  Arguments:
    arguments are typical for operations, assuming we are working with ID column as primary key

  Returns:
    returns same result as usual operation functions ( Generally nothing )

=cut

#**********************************************************
sub AUTOLOAD {
  our $AUTOLOAD;
  my ($entity_name, $operation) = $AUTOLOAD =~ /.*::(.*)_(add|del|change|info)$/;
  
  return if ($AUTOLOAD =~ /::DESTROY$/);
  
  die "Undefined function $AUTOLOAD. ()" unless ($operation && $entity_name);
  
  my ($self, $data, $attr) = @_;
  
  my $table = lc(__PACKAGE__) . '_' . $entity_name;
  
  if ( exists $UNUSUAL_TABLE_NAMES{$table} && $UNUSUAL_TABLE_NAMES{$table} ) {
    $table = $UNUSUAL_TABLE_NAMES{$table};
  }
  
  if ( $self->{debug} ) {
    _bp($table, { data => $data, attr => $attr });
  }
  
  if ( $operation eq 'add' ) {
    $self->query_add($table, $data);
    $admin->system_action_add( uc($entity_name) . ": $self->{INSERT_ID}", { TYPE => 1 });
    
    return $self->{errno} ? 0 : $self->{INSERT_ID};
  }
  elsif ( $operation eq 'del' ) {
    if ( ref $data ne 'HASH'){
      $data = { ID => $data };
    }
    $self->query_del($table, $data, $attr);
    $admin->system_action_add( uc($entity_name) . ": " . ($data || ''), { TYPE => 10 });
    return $self->{errno} ? 0 : 1;
  }
  elsif ( $operation eq 'change' ) {
    $admin->{MODULE} = $MODULE;
    return $self->changes2(
      {
        CHANGE_PARAM => 'ID',
        TABLE        => $table,
        DATA         => $data,
      }
    );
  }
  elsif ( $operation eq 'info' ) {
    my $list_func_name = $entity_name . "_list";
    
    if ( $data && ref $data ne 'HASH' ) {
      $attr->{ID} = $data;
    }
    
    my $list = $self->$list_func_name(
      {
        SHOW_ALL_COLUMNS => 1,
        COLS_UPPER       => 1,
        COLS_NAME        => 1,
        PAGE_ROWS        => 1,
        %{ $attr ? $attr : { } }
      }
    );
    
    return $list->[0] || { };
  }
  
  die "Wrong call $AUTOLOAD";
}

#**********************************************************

=head2 user_info() -

  Arguments:
    $uid - UID for user

  Returns:
    hashref

=cut

#**********************************************************
sub user_info() {
  my ($self, $uid) = @_;
  my $list = $self->user_list(
    {
      UID              => $uid,
      SHOW_ALL_COLUMNS => 1,
      COLS_UPPER       => 1,
      COLS_NAME        => 1,
      PAGE_ROWS        => 1
    }
  );
  
  return $list->[0] || { };
}

#**********************************************************

=head2 user_add($attr)

=cut

#**********************************************************
sub user_add {
  my $self = shift;
  my ($attr) = @_;
  
  $self->query_add('osbb_main', $attr);
  return [ ] if ($self->{errno});
  
  $admin->system_action_add("OSBB USERS: $self->{INSERT_ID}", { TYPE => 1 });
  return $self;
}

#**********************************************************

=head2  user_del($id)

=cut

#**********************************************************
sub user_del {
  my $self = shift;
  my ($id) = @_;
  
  $self->query_del('osbb_main', { ID => $id });
  
  return [ ] if ($self->{errno});
  
  $admin->system_action_add("OSBB USERS: $id", { TYPE => 10 });
  
  return $self;
}

#**********************************************************

=head2 user_change($attr)

=cut

#**********************************************************
sub user_change {
  my $self = shift;
  my ($attr) = @_;
  
  $attr->{DISABLE} = defined($attr->{DISABLE});
  
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
=head2 users_list($attr)

  Arguments:
    $attr - hash_ref

  Returns:
    list

=cut
#**********************************************************
sub user_list {
  my ($self, $attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG   = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $search_columns = [
    [ 'OWNERSHIP_TYPE','INT', 'om.ownership_type', 1 ],
    [ 'TOTAL_AREA',    'INT', 'om.total_area',   1 ],
    [ 'LIVING_AREA',   'INT', 'om.living_area',  1 ],
    [ 'UTILITY_AREA',  'INT', 'om.utility_area', 1 ],
    [ 'BALCONY_AREA',  'INT', 'om.balcony_area', 1 ],
    [ 'USEFUL_AREA',   'INT', 'om.useful_area',  1 ],
    [ 'ROOMS_COUNT',   'INT', 'om.rooms_count',  1 ],
    [ 'PEOPLE_COUNT',  'INT', 'om.people_count', 1 ],
    [ 'UID',           'INT', 'om.uid',          1 ],
  ];
  
 # if ( $attr->{SHOW_ALL_COLUMNS} ) {
 #   map { $attr->{ $_->[0] } = '_SHOW' unless (exists $attr->{ $_->[0] }) } @{$search_columns};
 # }
  
  my $WHERE = $self->search_former(
    $attr,
    $search_columns,
    {
      WHERE             => 1,
      USERS_FIELDS      => 1,
      USE_USER_PI       => 1,
      SKIP_USERS_FIELDS => [ 'UID' ]
    }
  );
  
  my $EXT_TABLES = $self->{EXT_TABLES} || q{};
  
  $self->query2(
    "SELECT $self->{SEARCH_FIELDS} om.uid
   FROM osbb_main om
   LEFT JOIN users u ON (u.uid=om.uid)
   $EXT_TABLES
   $WHERE
   ORDER BY $SORT $DESC
   LIMIT $PG, $PAGE_ROWS;",
    undef,
    {
      COLS_NAME => 1,
      %{ $attr // { } }
    }
  );
  
  return [ ] if ($self->{errno});
  
  return $self->{list};
}

#**********************************************************
=head2 spending_types_list($attr)

=cut
#**********************************************************
sub spending_type_list {
  my $self = shift;
  my ($attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $WHERE = $self->search_former($attr, [ ], { WHERE => 1, });
  
  $self->query2(
    "SELECT
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
  
  if ( $self->{TOTAL} >= 0 ) {
    $self->query2("SELECT COUNT(id) AS total FROM osbb_spending_types $WHERE", undef, { INFO => 1 });
  }
  
  return $list;
}

#**********************************************************
=head2 users_services_list($attr)

=cut
#**********************************************************
sub users_services_list {
  my $self = shift;
  my ($attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $WHERE = $self->search_former($attr, [
      [ 'UID', 'INT', 'uid', ],
      [ 'TP_ID', 'INT', 'tp_id', ]
    ], { WHERE => 1, }
  );
  
  $self->query2(
    "SELECT
     uid,
     tp_id,
     id
     FROM osbb_users_services
     $WHERE
     ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;",
    undef,
    $attr
  );
  
  return [ ] if ($self->{errno});
  
  my $list = $self->{list};
  
  if ( $self->{TOTAL} >= 0 ) {
    $self->query2("SELECT COUNT(id) AS total FROM osbb_user_services $WHERE", undef, { INFO => 1 });
  }
  
  return $list;
}

#**********************************************************

=head2 osbb_tarifs_list($attr)

=cut

#**********************************************************
sub osbb_tarifs_list {
  my $self = shift;
  my ($attr) = @_;
  
  my $SORT = ($attr->{SORT}) ? $attr->{SORT} : 1;
  my $DESC = ($attr->{DESC}) ? $attr->{DESC} : 'DESC';
  my $PG = ($attr->{PG}) ? $attr->{PG} : 0;
  my $PAGE_ROWS = ($attr->{PAGE_ROWS}) ? $attr->{PAGE_ROWS} : 25;
  
  my @WHERE_RULES = ();
  
  if ($admin->{DOMAIN_ID}) {
    push @WHERE_RULES,  @{ $self->search_expr($admin->{DOMAIN_ID}, 'INT', 'ot.domain_id') };
  }
  
  my $WHERE = $self->search_former(
    $attr,
    [ [ 'ID', 'INT', 'ot.id', 1 ],
      [ 'NAME', 'STR', 'ot.name', 1 ],
      [ 'UNIT', 'INT', 'ot.unit', 1 ],
      [ 'PRICE', 'INT', 'ot.price', 1 ],
      [ 'DOCUMENT_BASE', 'INT', 'ot.document_base', 1 ],
      [ 'START_DATE', 'DATE', 'ot.start_date', 1 ],
    ],
    {
      WHERE       => 1,
      WHERE_RULES => \@WHERE_RULES
    }
  );
  
  $self->query2(
    "SELECT ot.*
  FROM osbb_tarifs ot
  $WHERE
  GROUP BY ot.id
  ORDER BY $SORT $DESC
  LIMIT $PG, $PAGE_ROWS;",
    undef,
    $attr
  );
  
  my $list = $self->{list};
  
  $self->query2(
    "SELECT COUNT(*) AS total
    FROM osbb_tarifs ot
    $WHERE;",
    undef,
    { INFO => 1 },
  );
  
  return $list;
}

#**********************************************************
=head2 ownership_types_list($attr)

  Arguments:
    $attr - hash_ref

  Returns:
    list

=cut
#**********************************************************
sub ownership_types_list{
  my ($self, $attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $search_columns = [
    [ 'ID', 'INT', 'id', 1 ],
    [ 'NAME', 'STR', 'name', 1 ],
  ];
  
  if ( $attr->{SHOW_ALL_COLUMNS} ) {
    map { $attr->{$_->[0]} = '_SHOW' unless (exists $attr->{$_->[0]}) } @{$search_columns};
  }
  my $WHERE = $self->search_former($attr, $search_columns, { WHERE => 1 });
  
  $self->query2( "SELECT $self->{SEARCH_FIELDS} id
   FROM osbb_ownership_types
   $WHERE ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;", undef, {
      COLS_NAME => 1,
      %{ $attr // { }} }
  );
  
  return [ ] if ($self->{errno});
  
  return $self->{list};
}

#**********************************************************
=head2 ownership_types_list($attr)

  Arguments:
    $attr - hash_ref

  Returns:
    list

=cut
#**********************************************************
sub cashbox_list{
  my ($self, $attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $search_columns = [
    [ 'ID', 'INT', 'id', 1 ],
    [ 'NAME', 'STR', 'name', 1 ],
    [ 'DOMAIN_ID', 'INT', 'domain_id', 1 ],
  ];
  
  if ( $attr->{SHOW_ALL_COLUMNS} ) {
    map { $attr->{$_->[0]} = '_SHOW' unless (exists $attr->{$_->[0]}) } @{$search_columns};
  }
  my $WHERE = $self->search_former($attr, $search_columns, { WHERE => 1 });
  
  $self->query2( "SELECT $self->{SEARCH_FIELDS} id
   FROM osbb_cashbox
   $WHERE ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;", undef, {
      COLS_NAME => 1,
      %{ $attr // { }} }
  );
  
  return [ ] if ($self->{errno});
  
  return $self->{list};
}

#**********************************************************
=head2 ownership_types_list($attr)

  Arguments:
    $attr - hash_ref

  Returns:
    list

=cut
#**********************************************************
sub cashbox_coming_list{
  my ($self, $attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $search_columns = [
    [ 'ID', 'INT', 'id', 1 ],
    [ 'SUM', 'INT', 'sum', 1 ],
    [ 'UID', 'INT', 'uid', 1 ],
    [ 'AID', 'INT', 'aid', 1 ],
    [ 'DATE', 'DATE', 'date', 1 ],
    [ 'COMMENTS', 'STR', 'comments', 1 ],
    [ 'CASHBOX_ID', 'DATE', 'cashbox_id',  ],
    [ 'FROM_DATE|TO_DATE', 'DATE', "DATE_FORMAT(date, '%Y-%m-%d')" ],
  ];
  
  if ( $attr->{SHOW_ALL_COLUMNS} ) {
    map { $attr->{$_->[0]} = '_SHOW' unless (exists $attr->{$_->[0]}) } @{$search_columns};
  }
  my $WHERE = $self->search_former($attr, $search_columns, { WHERE => 1 });
  
  $self->query2( "SELECT $self->{SEARCH_FIELDS} id
   FROM osbb_cashbox_coming
   $WHERE ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;", undef, {
      COLS_NAME => 1,
      %{ $attr // { }} }
  );
  
  return [ ] if ($self->{errno});
  
  return $self->{list};
}

#**********************************************************
=head2 ownership_types_list($attr)

  Arguments:
    $attr - hash_ref

  Returns:
    list

=cut
#**********************************************************
sub cashbox_spending_list{
  my ($self, $attr) = @_;
  
  my $SORT = $attr->{SORT} || 'id';
  my $DESC = ($attr->{DESC}) ? '' : 'DESC';
  my $PG = $attr->{PG} || '0';
  my $PAGE_ROWS = $attr->{PAGE_ROWS} || 25;
  
  my $search_columns = [
    [ 'ID', 'INT', 'id', 1 ],
    [ 'SUM', 'INT', 'sum', 1 ],
    [ 'UID', 'INT', 'uid', 1 ],
    [ 'AID', 'INT', 'aid', 1 ],
    [ 'DATE', 'DATE', 'date', 1 ],
    [ 'COMMENTS', 'STR', 'comments', 1 ],
    [ 'CASHBOX_ID', 'DATE', 'cashbox_id',  ],
    [ 'FROM_DATE|TO_DATE', 'DATE', "DATE_FORMAT(date, '%Y-%m-%d')" ],
  ];
  
  if ( $attr->{SHOW_ALL_COLUMNS} ) {
    map { $attr->{$_->[0]} = '_SHOW' unless (exists $attr->{$_->[0]}) } @{$search_columns};
  }
  my $WHERE = $self->search_former($attr, $search_columns, { WHERE => 1 });
  
  $self->query2( "SELECT $self->{SEARCH_FIELDS} id
   FROM osbb_cashbox_spending
   $WHERE ORDER BY $SORT $DESC LIMIT $PG, $PAGE_ROWS;", undef, {
      COLS_NAME => 1,
      %{ $attr // { }} }
  );
  
  return [ ] if ($self->{errno});
  
  return $self->{list};
}

DESTROY { }

1;
