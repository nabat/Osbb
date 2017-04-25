<style>
  thead > tr > button.form-control {
    margin-top: 5px
  }
</style>
<form name='form_PREVIEW_IMPORT' id='form_PREVIEW_IMPORT' method='post' class='form form-horizontal'>
  <input type='hidden' name='index' value='$index'/>
  <input type='hidden' name='import' value='1'/>
  <input type='hidden' name='file_columns' value='%FILE_COLUMNS%'/>

  <div class='box box-theme box-form'>
    <div class='box-body' id='import-form-body-wrapper'>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='LOCATION_ID'>_{ADDRESS}_</label>
        <div class='col-md-9'>
          %LOCATION_ID_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='PASSWORD_ID'>_{PASSWD}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' name='PASSWORD' id='password' value='%PASSWORD%'
                 data-event-onchange='1'>
        </div>
      </div>

    </div>
  </div>


  %TABLE%

  <div class='box-footer text-center'>
    <a href='?index=$index' class='btn btn-default'>_{BACK}_</a>
    <input type='submit' class='btn btn-primary' name='import' value='_{IMPORT}_'>
  </div>
</form>

<script>
  window['IMPORT_LANG'] = {
    'REMOVE': '_{REMOVE}_',
    'CHOOSE': '_{CHOOSE}_'
  };
</script>

<script src='/styles/default_adm/js/import_preview.js'></script>

<script>
  jQuery(function () {
    'use strict';

    // All existing columns
    var columns_for_import = JSON.parse('%COLUMNS%');
    var table_id           = '%TABLE_ID%';

    var dynamic_table = new DynamicTable(table_id, {
      headings: new PossibleColumns(columns_for_import)
    });

    if (!table_id || !dynamic_table) {
      alert('Import table without id or you passed me wrong id : ' + table_id);
    }

    // Set table inputs update value when template values has been changed
    //  Exceptions are
    //  1. Already have value and it was not assigned from template
    //  2. Has flag indicating it was changed by hands

    jQuery('#import-form-body-wrapper').find('input').on('input', function () {
      var new_val = this.value;

      dynamic_table.getInputsForName(this.name.toLowerCase()).each(function (i, t_inp) {
        var table_input = jQuery(t_inp);

        if (table_input.val() && table_input.data('hand_changed')) {
          return;
        }

        // Edit in any case if don't have value
        if (!table_input.val() || table_input.data('auto_changed') === true) {
          t_inp.val(new_val);
          table_input.data('auto_changed', true);
          table_input.data('hand_changed', false);
        }

        table_input.off('input');
        table_input.on('input', function () {

          if (!table_input.data('hand_changed') && table_input.data('auto_changed')) {
            table_input.data('hand_changed', true);
            table_input.data('auto_changed', false);
          }

        });

      });

    });


  });
</script>