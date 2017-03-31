use strict;
use warnings FATAL => 'all';

use Abills::Base qw/convert _bp/;
use JSON;

our(
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
    uid              => 'UID',
    fio              => $lang{FIO},
    phone            => $lang{PHONE},
    address_district => $lang{DISTRICT},
    address_street   => $lang{STREET},
    address_build    => $lang{BUILD},
    address_flat     => $lang{FLAT},
    
  );
  
  if ( !$FORM{FILE} ) {
    
    my $type_select = $html->form_select('FILE_FORMAT', {
        SEL_ARRAY   => [ 'CSV', 'JSON' ],
        NO_ARRAY_ID => 1
      });
    
    $html->tpl_show(_include('osbb_import_file_form', 'Osbb'),
      {
        FILE_FORMAT_SELECT => $type_select
      }
    );
    
    return 1;
  }
  elsif ( $FORM{preview} ) {
    
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
  
    my $current_row_num = 0;
    # Take every row, and make input from row
    # Now using column names from file, later will receive normal names
    
    my @table_rows = ();
    for ( my $i = 0, my $len = scalar @$rows; $i < $len; $i++ ) {
      my @new_row = ();
      
      my $current_file_row = $rows->[$i];
      for ( my $j = 0, my $columns_number = scalar @$file_columns; $j < $columns_number; $j++ ) {
        
        push (@new_row,
          $html->form_input(
            $i . '_' . $file_columns->[$j],
            $current_file_row->[$j],
            {
              EX_PARAMS => ' data-original-column-name="' . $file_columns->[$j] . '"'
            }
          )
        );
        
      }
      
      push ( @table_rows,  [ @new_row ]);
    }
  
    $table->addrow(@$_) for @table_rows;
    
    $html->tpl_show(_include('osbb_import_preview_form', 'Osbb'), {
        TABLE        => $table->show(),
        COLUMNS      => JSON::to_json(\%columns),
        TABLE_ID     => $table->{ID} . '_',
        FILE_COLUMNS => join(',', @$file_columns)
      });
    
    return 1;
  }
  elsif ( $FORM{import} ) {
  
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
  
  if ( $file_format eq 'CSV' ) {
    
    my $content = $upload_obj->{Contents};
    my $delimiter = ';';
    my @file_rows = split(/\r?\n/, $content);
    
    my @columns = split($delimiter, shift @file_rows);
    
    my @users_rows = ();
    foreach my $file_row ( @file_rows ) {
      next if (!$file_row || $file_row !~ /$delimiter/ );
      push @users_rows, [ split($delimiter, $file_row ) ];
    }
    
    return (\@columns, \@users_rows);
  }
  elsif ( $file_format eq 'JSON' ) {
    my $json_load_error = load_pmodule( "JSON", { RETURN => 1 } );
    if ( $json_load_error ) {
      print $json_load_error;
      return 0;
    }
    my $json = JSON->new()->utf8(0);
    
  }
  
  return [ ];
}


1;