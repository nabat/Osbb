use strict;
use warnings FATAL => 'all';

use Abills::Base qw/convert _bp/;
use JSON;

our (
  %lang,
  $html,
  $admin,
  $db,
  %permissions,
  %ADMIN_REPORT,
  %err_strs,
  $Osbb,
);


#**********************************************************
=head2 _osbb_users_import()

=cut
#**********************************************************
sub _osbb_users_import {
  
  my %columns = (
    uid          => 'UID',
    password     => $lang{PASSWD},
    fio          => $lang{FIO},
    phone        => $lang{PHONE},
    address_flat => $lang{FLAT},
    type         => $lang{TYPE},
    total_area   => $lang{TOTAL_AREA},
    living_area  => $lang{LIVING_AREA},
    utility_area => $lang{UTILITY_AREA},
    balcony_area => $lang{BALCONY_AREA},
    useful_area  => $lang{USEFUL_AREA},
    rooms_count  => $lang{ROOMS_COUNT},
    people_count => $lang{PEOPLE_COUNT},
  );
  
  if ( $FORM{preview} ) {
    
    $html->message('info alert-sm', $lang{TIP}, $lang{FILL_DEFAULT_VALUES_THAT_WILL_REPLACE_EMPTY_FILE_FIELDS});
    
    my ($file_columns, $rows) = osbb_parse_import_file($FORM{FILE_FORMAT}, $FORM{FILE});
    
    my $table = $html->table( {
      width       => '100%',
      caption     => "$lang{IMPORT} : $lang{PREVIEW}",
      border      => 1,
      title_plain => $file_columns,
      qs          => $pages_qs,
      ID          => 'OSBB_IMPORT_PREVIEW_TABLE'
    } );
    
    my @table_rows = ();
    for ( my $row_num = 0, my $len = scalar @{$rows}; $row_num < $len; $row_num++ ) {
      my @new_row = ();
      
      my $current_file_row = $rows->[$row_num];
      for ( my $j = 0, my $columns_number = scalar @{$file_columns}; $j < $columns_number; $j++ ) {
        
        push (@new_row,
          $html->form_input(
            $row_num . '_' . $file_columns->[$j],
            $current_file_row->[$j],
            {
              EX_PARAMS => ' data-original-column-name="' . $file_columns->[$j] . '"'
                . ' data-original-column-row="' . $row_num . '"'
              
            }
          )
        );
        
      }
      
      push ( @table_rows, [ @new_row ]);
    }
    
    $table->addrow(@{$_}) for (@table_rows);
    
    delete $FORM{__BUFFER};
    $html->tpl_show(templates('form_import_preview'), {
        FORM_GROUPS  => $html->tpl_show(
          _include('osbb_import_preview_form', 'Osbb'),
          {
            LOCATION_ID_SELECT => osbb_simple_build_select({ REQUIRED => 1 }),
            %FORM,
          },
          { OUTPUT2RETURN => 1 }),
        TABLE        => $table->show(),
        COLUMNS      => JSON::to_json(\%columns),
        TABLE_ID     => $table->{ID} . '_',
        FILE_COLUMNS => join(',', @{$file_columns}),
      });
    
    return 1;
  }
  elsif ( $FORM{import} ) {
    # Parse %FORM
    my @rows = @{ osbb_parse_import_preview_form(keys %columns) };
    _bp('rows', \@rows);
    
  }
  else {
    
    my $type_select = $html->form_select('FILE_FORMAT', {
        SEL_ARRAY   => [ 'CSV', 'JSON' ],
        NO_ARRAY_ID => 1
      });
    
    $html->tpl_show(_include('osbb_import_file_form', 'Osbb'),
      {
        FILE_FORMAT_SELECT => $type_select,
        LOCATION_ID_SELECT => osbb_simple_build_select({ REQUIRED => 1 })
      }
    );
    
    return 1;
    
  }
  
}

#**********************************************************
=head2 osbb_parse_import_file($file_format, $upload_obj) - parses file

  Arguments:
    $file_format - CSV|JSON
    $upload_obj  - ref to $FORM{upload}
    
  Returns:
    list - ([@column_names], [ %users_rows ])

=cut
#**********************************************************
sub osbb_parse_import_file {
  my ($file_format, $upload_obj) = @_;
  
  return 0 unless ($file_format && $upload_obj && ref $upload_obj eq 'HASH');
  
  my $content = $upload_obj->{Contents};
  my @users_rows = ();
  
  if ( $file_format eq 'CSV' ) {
    
    # Prepare
    my $delimiter = ';';
    my @file_rows = split(/\r?\n/, $content);
    
    # Parse
    my @columns = split($delimiter, shift @file_rows);
    foreach my $file_row ( @file_rows ) {
      next if (!$file_row || $file_row !~ /$delimiter/ );
      push @users_rows, [ split($delimiter, $file_row ) ];
    }
    
    return (\@columns, \@users_rows);
  }
  elsif ( $file_format eq 'JSON' ) {
    my $json = JSON->new()->utf8(0);
    
    # Prepare
    my $content_parsed;
    eval { $content_parsed = $json->encode($content) };
    if ( $! ) {
      $html->message('err', $lang{ERROR}, $!);
      return [ ];
    }
    
    # Parse
    # $content_parsed should be list
    if ( ref $content_parsed ne 'ARRAY' ) {
      $html->message('err', $lang{ERROR}, $lang{ERR_WRONG_DATA});
      return [];
    }
    
    my %columns_hash = ();
    foreach my $user_row ( @{$content_parsed} ) {
      next if (ref $user_row ne 'HASH');
      $columns_hash{$_} = 1 foreach (keys %{$user_row});
    }
    
    return ( [ keys %columns_hash ], $content_parsed );
  }
  
  return [ ];
}

#**********************************************************
=head2 osbb_parse_import_preview_form()

=cut
#**********************************************************
sub osbb_parse_import_preview_form {
  my (@col_names) = @_;
  my @rows = ();
  
  my $rows_count = $FORM{rows};
  
  if ( !$rows_count ) {
    $html->message('err', $lang{ERR_NO_DATA});
    return 0;
  }
  for ( my $row_num = 0; $row_num < $rows_count; $row_num++ ) {
    my %row = ();
    
    foreach my $col_name ( @col_names ) {
      if ( exists $FORM{$row_num . '_' . $col_name} && defined $FORM{$row_num . '_' . $col_name} ) {
        $row{$col_name} = $FORM{$row_num . '_' . $col_name};
      }
    }
    
    push (@rows, \%row);
  }
  
  return wantarray ? @rows : \@rows;
}

1;