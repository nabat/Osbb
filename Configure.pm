=head2 NAME

  OSBB Configure

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


my $Osbb = Osbb->new($db, $admin, \%conf);


#**********************************************************
=head2 osbb_config($attr)

=cut
#**********************************************************
sub osbb_config {


  return 1;
}

#********************************************************
=head2 osbb_area_types()

=cut
#********************************************************
sub osbb_area_types{

  $Osbb->{ACTION} = 'add';
  $Osbb->{LNG_ACTION} = "$lang{ADD}";

  if ( $FORM{add} ){
    $Osbb->area_type_add( { %FORM } );
    if ( !$Osbb->{errno} ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{ADDED}" );
    }
  }
  elsif ( $FORM{change} ){
    $Osbb->area_type_change( \%FORM );
    if ( !_error_show( $Osbb ) ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{CHANGED}" );
    }
  }
  elsif ( $FORM{chg} ){
    $Osbb->area_type_info( "$FORM{chg}" );

    if ( !$Osbb->{errno} ){
      $Osbb->{ACTION} = 'change';
      $Osbb->{LNG_ACTION} = "$lang{CHANGE}";
      $FORM{add_form} = 1;
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{CHANGING}" );
    }
  }
  elsif ( $FORM{del} && $FORM{COMMENTS} ){
    $Osbb->area_type_del( "$FORM{del}" );
    if ( !$Osbb->{errno} ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{DELETED}" );
    }
  }

  _error_show( $Osbb );

  if ( $FORM{add_form} ){
    $html->tpl_show( _include( 'osbb_area_types', 'Osbb' ), $Osbb );
  }

  result_former({
    INPUT_DATA      => $Osbb,
    FUNCTION        => 'area_type_list',
    BASE_FIELDS     => 4,
    FUNCTION_FIELDS => 'change,del',
    SKIP_USER_TITLE => 1,
    EXT_TITLES      => {
      name         => $lang{TYPE},
      living_space => $lang{LIVING_SPACE},
      utility_room => $lang{UTILITY_ROOM},
      total_space  => $lang{TOTAL_SPACE}
    },
    TABLE           => {
      width   => '100%',
      caption => $lang{AREA_TYPES},
      qs      => $pages_qs,
      ID      => 'AREA_TYPES',
      EXPORT  => 1,
      MENU    => "$lang{ADD}:index=$index&add_form=1&$pages_qs:add",
    },
    MAKE_ROWS       => 1,
    SEARCH_FORMER   => 1,
    TOTAL           => 1
  });

  return 1;
}

#**********************************************************
=head2 osbb_spending_types() -

  Arguments:
    $attr -
  Returns:

  Examples:

=cut
#**********************************************************
sub osbb_spending_types {
  my ($attr) = @_;

  $Osbb->{ACTION}     = 'add';
  $Osbb->{LNG_ACTION} = $lang{ADD};

   if ( $FORM{add} ){
    $Osbb->spending_type_add( { %FORM } );
    if ( !$Osbb->{errno} ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{ADDED}" );
    }
  }
  elsif ( $FORM{change} ){
    $Osbb->spending_type_change( \%FORM );
    if ( !_error_show( $Osbb ) ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{CHANGED}" );
    }
  }
  elsif ( $FORM{chg} ){
    $Osbb->spending_type_info( "$FORM{chg}" );

    if ( !$Osbb->{errno} ){
      $Osbb->{ACTION} = 'change';
      $Osbb->{LNG_ACTION} = "$lang{CHANGE}";
      $FORM{add_form} = 1;
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{CHANGING}" );
    }
  }
  elsif ( $FORM{del} && $FORM{COMMENTS} ){
    $Osbb->area_type_del( "$FORM{del}" );
    if ( !$Osbb->{errno} ){
      $html->message( 'info', $lang{AREA_TYPES}, "$lang{DELETED}" );
    }
  }

  if ( $FORM{add_form} ){
    $html->tpl_show( _include( 'osbb_spending_types', 'Osbb' ), $Osbb );
  }

  result_former({
    INPUT_DATA      => $Osbb,
    FUNCTION        => 'spending_type_list',
    BASE_FIELDS     => 2,
    FUNCTION_FIELDS => 'change,del',
    SKIP_USER_TITLE => 1,
    EXT_TITLES      => {
      name         => $lang{NAME},
      comments     => $lang{COMMENTS},
    },
    TABLE           => {
      width   => '100%',
      caption => "$lang{SPENDING} $lang{TYPE}",
      qs      => $pages_qs,
      ID      => 'SPENDING_TYPES',
      EXPORT  => 1,
      MENU    => "$lang{ADD}:index=$index&add_form=1&$pages_qs:add",
    },
    MAKE_ROWS       => 1,
    SEARCH_FORMER   => 1,
    TOTAL           => 1
  });

  return 1;
}

1;