
=head1 NAME

  Osbb Tarifs

=cut

use warnings;
use strict;

our ($db, $admin, %lang, $html, %ADMIN_REPORT);

my $Osbb = Osbb->new($db, $admin, \%conf);

my @units = ('', 'По площади', 'По количетву физ. лиц', 'Фиксированная сумма');
#**********************************************************

=head2 osbb_tarifs()

=cut

#**********************************************************
sub osbb_tarifs {

  if ($FORM{add_form} || $FORM{chg}) {
    $Osbb->osbb_tarifs_info($FORM{chg}) if ($FORM{chg});

    $Osbb->{UNITS_SEL} = $html->form_select(
      'UNIT',
      {
        SELECTED => $FORM{UNIT} || $Osbb->{UNIT} || '',
        SEL_ARRAY    => \@units,
        ARRAY_NUM_ID => 1
      }
    );

    $Osbb->{SET_ALL_CHEK} = 'checked' if ($Osbb->{SET_ALL});
  }

  if ($FORM{add_form}) {
    $Osbb->{ACTION}     = 'added';
    $Osbb->{ACTION_LNG} = $lang{ADD};

    $html->message('info', $lang{INFO}, "$lang{ADD}");

    $html->tpl_show(_include('osbb_tarifs', 'Osbb'), {%$Osbb});
  }
  elsif ($FORM{added}) {
    $Osbb->osbb_tarifs_add({%FORM});

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{ADDED}");
    }
  }
  elsif ($FORM{del}) {
    $Osbb->osbb_tarifs_del({ ID => $FORM{del} });

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{DELETED}");
    }
  }
  elsif ($FORM{chg}) {

    if (!$Osbb->{errno}) {
      $Osbb->{ACTION}     = 'change';
      $Osbb->{ACTION_LNG} = $lang{CHANGE};

      $html->message('info', $lang{INFO}, "$lang{CHANGE}");

      $html->tpl_show(_include('osbb_tarifs', 'Osbb'), {%$Osbb});
    }
  }
  elsif ($FORM{change}) {
    $FORM{SET_ALL} = $FORM{SET_ALL} ? $FORM{SET_ALL} : 0;
    $Osbb->osbb_tarifs_change({%FORM});

    if (!$Osbb->{errno}) {
      $html->message('info', $lang{INFO}, "$lang{CHANGED}") if (!$Osbb->{errno});
    }
  }

  if (!($FORM{add_form} || $FORM{chg})) {
    result_former(
      {
        INPUT_DATA      => $Osbb,
        FUNCTION        => 'osbb_tarifs_list',
        DEFAULT_FIELDS  => 'ID, NAME, UNIT, PRICE, DOCUMENT_BASE, START_DATE, SET_ALL',
        FUNCTION_FIELDS => 'change,del',
        EXT_TITLES      => {
          id            => '#',
          name          => $lang{NAME},
          unit          => $lang{UNIT},
          price         => $lang{PRICE},
          document_base => $lang{DOCUMENT_BASE},
          start_date    => $lang{COME_INTO_FORCE},
          set_all       => $lang{SET_TARIF_TO_ALL},
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
          MENU    => "$lang{ADD}:add_form=1&index=$index:add"
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
