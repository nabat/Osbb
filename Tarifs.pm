=head1 NAME

  Osbb Tarifs

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

my @payment_type = ('', 'По площади', 'По количетву физ. лиц');

#**********************************************************
=head2 osbb_tarifs()

=cut
#**********************************************************
sub osbb_tarifs {
  my %info;


  if($FORM{add_form} || $FORM{chg}){

    $Osbb->{PAYMENT_TYPE_SEL} = $html->form_select('PAYMENT_TYPE', {
      SELECTED    =>  $FORM{PAYMENT_TYPE} || '',
      SEL_ARRAY    => \@payment_type,
      ARRAY_NUM_ID => 1
    });
  }

  if($FORM{add_form}){
    $Osbb->{ACTION} = 'added';
    $Osbb->{ACTION_LNG} = $lang{ADD};

    $html->message( 'info', $lang{INFO}, "$lang{ADD}" );

    $html->tpl_show(_include('osbb_tarifs','Osbb'), { %$Osbb });
  }
  elsif($FORM{added}){
    $Osbb->osbb_tarifs_add({%FORM});

    if(!$Osbb->{errno}){
      $html->message( 'info', $lang{INFO}, "$lang{ADDED}" );
    }
    else{
      $html->message( 'err', $lang{ERROR}, $Osbb->{errno} );
    }
  }
  elsif($FORM{del}){
    $Osbb->osbb_tarifs_del({ID => $FORM{del}});

    if(!$Osbb->{errno}){
      $html->message( 'info', $lang{INFO}, "$lang{DELETED}" );
    }
    else{
      $html->message( 'err', $lang{ERROR}, $Osbb->{errno} );
    }
  }
  elsif($FORM{chg}){
    $Osbb->osbb_tarifs_info($FORM{chg});

    if (!$Osbb->{errno}) {
      $Osbb->{ACTION} = 'change';
      $Osbb->{ACTION_LNG} = $lang{CHANGE};

      $html->message( 'info', $lang{INFO}, "$lang{CHANGE}" );

      $html->tpl_show(_include('osbb_tarifs','Osbb'), { %$Osbb });
    }
    else{
      $html->message( 'err', $lang{ERROR}, $Osbb->{errno} );
    }
  }
  elsif($FORM{change}){
    $Osbb->osbb_tarifs_change({%FORM});

    if(!$Osbb->{errno}){
      $html->message( 'info', $lang{INFO}, "$lang{CHANGED}" ) if (!$Osbb->{errno});
    }
    else{
      $html->message( 'err', $lang{ERROR}, $Osbb->{errno} );
    }
  }

  result_former({
    INPUT_DATA      => $Osbb,
    FUNCTION        => 'osbb_tarifs_list',
    DEFAULT_FIELDS  => 'ID, NAME, PAYMENT_TYPE, PRICE, DOCUMENT_BASE',
    FUNCTION_FIELDS => 'change,del',
    EXT_TITLES      => {
      id            => '#',
      name          => $lang{NAME},
      payment_type  => $lang{PAYMENT_TYPE},
      price         => $lang{PRICE},
      document_base => $lang{DOCUMENT_BASE},
    },
    SKIP_USER_TITLE => 1,
    FILTER_COLS  => {
      payment_type => '_get_payment_type',
    },
    TABLE           => {
      width   => '100%',
      caption => "$lang{TARIFS}",
      qs      => $pages_qs,
      ID      => 'TARIFS',
      MENU    => "$lang{ADD}:add_form=1&index=$index:add"
    },
    MAKE_ROWS => 1,
    TOTAL     => 1
  });

 return 1;
}

sub _get_payment_type {
  my ($payment_type_id) = @_;

  return $payment_type[$payment_type_id];
}

1
