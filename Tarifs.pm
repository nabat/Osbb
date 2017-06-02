
=head1 NAME

  Osbb Tarifs

=cut

use warnings;
use strict;

our ($db, $admin, %lang, $html, %ADMIN_REPORT);

my $Osbb = Osbb->new($db, $admin, \%conf);

my @units = ('', $lang{BY_AREA}, $lang{BY_HOUSING_COUNT}, $lang{FIXED_AMOUNT});
#**********************************************************

=head2 osbb_tarifs()

=cut

#**********************************************************
sub osbb_tarifs {
  my $tarif_info = ();
  if ($FORM{add_form} || $FORM{chg}) {
    $tarif_info = $Osbb->osbb_tarifs_info($FORM{chg}, { COLS_UPPER => 1, COLS_NAME => 1 }) if ($FORM{chg});

    $Osbb->{UNITS_SEL} = $html->form_select('UNIT', {
      SELECTED     => $FORM{UNIT} || $tarif_info->{UNIT} || '',
      SEL_ARRAY    => \@units,
      ARRAY_NUM_ID => 1
    });
  }

  if ($FORM{add_form}) {
    $Osbb->{ACTION}     = 'added';
    $Osbb->{ACTION_LNG} = $lang{ADD};

    $html->message('info', $lang{INFO}, "$lang{ADD}");

    $html->tpl_show(_include('osbb_tarifs', 'Osbb'), {%$Osbb, %$tarif_info});
  }
  elsif ($FORM{added}) {
    $Osbb->tarifs_add({%FORM});

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{ADDED}");
    }
    if ($FORM{SET_ALL}) {
      my $new_tp = $Osbb->{INSERT_ID};
      my $user_list = $Osbb->user_list({ PAGE_ROWS => 9999 });
      foreach (@$user_list) {
        $Osbb->users_services_add({ UID => $_->{uid}, TP_ID => $new_tp })
      }
    }
  }
  elsif ($FORM{del}) {
    $Osbb->tarifs_del({ ID => $FORM{del} });

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{DELETED}");
    }
  }
  elsif ($FORM{chg}) {
    if (!$Osbb->{errno}) {
      $Osbb->{ACTION}     = 'change';
      $Osbb->{ACTION_LNG} = $lang{CHANGE};

      $html->message('info', $lang{INFO}, "$lang{CHANGE}");
      $html->tpl_show(_include('osbb_tarifs', 'Osbb'), { %$Osbb, %$tarif_info });
    }
  }
  elsif ($FORM{change}) {
    $Osbb->tarifs_change({%FORM});

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{CHANGED}") if (!$Osbb->{errno});
    }
    if ($FORM{SET_ALL}) {
      my $user_list = $Osbb->user_list({ PAGE_ROWS => 9999 });
      foreach (@$user_list) {
        $Osbb->users_services_add({ UID => $_->{uid}, TP_ID => $FORM{ID} })
      }
    }
  }

  if (!($FORM{add_form} || $FORM{chg})) {
    result_former(
      {
        INPUT_DATA      => $Osbb,
        FUNCTION        => 'osbb_tarifs_list',
        DEFAULT_FIELDS  => 'ID, NAME, UNIT, PRICE, DOCUMENT_BASE',#, START_DATE',
        FUNCTION_FIELDS => 'change,del',
        EXT_TITLES      => {
          id            => '#',
          name          => $lang{NAME},
          unit          => $lang{UNIT},
          price         => $lang{PRICE},
          document_base => $lang{DOCUMENT_BASE},
          start_date    => $lang{COME_INTO_FORCE},
        },
        SKIP_USER_TITLE => 1,
        FILTER_COLS     => {
          unit    => '_get_unit',
          set_all => '_get_set_all',
        },
        TABLE => {
          width   => '100%',
          caption => "$lang{TARIFS}",
          qs      => $pages_qs,
          ID      => 'TARIFS',
          MENU    => "$lang{ADD}:add_form=1&index=$index:btn bg-olive margin;"
        },
        MAKE_ROWS => 1,
        TOTAL     => 1,
      }
    );
  }

  _error_show($Osbb);

  return 1;
}

sub _get_unit {
  my ($unit_id) = @_;

  return $units[$unit_id] ? $units[$unit_id] : '';
}

sub _get_set_all {
  my ($set) = @_;

  return $set ? $lang{YES} : $lang{NO};
}

1
