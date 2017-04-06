<div class='box box-theme box-form'>
  <div class='box-header with-border'><h4 class='box-title'>_{IMPORT}_</h4></div>
  <div class='box-body'>
    <form name='OSBB_IMPORT_FILE' id='form_OSBB_IMPORT_FILE' method='post' enctype='multipart/form-data' class='form form-horizontal'>
      <input type='hidden' name='index' value='$index' />
      <input type='hidden' name='import' value='1' />

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_FORMAT'>_{TYPE}_</label>
        <div class='col-md-9'>
          %FILE_FORMAT_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_ID'>_{FILE}_</label>
        <div class='col-md-9'>
          <input type='file' class='form-control' required='required' name='FILE'  id='FILE_ID'  />
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_ID'>_{ADDRESS}_</label>
        <div class='col-md-9'>
          %LOCATION_ID_SELECT%
        </div>
      </div>


    </form>

  </div>
  <div class='box-footer text-center'>
    <input type='submit' form='form_OSBB_IMPORT_FILE' class='btn btn-primary' name='preview' value='_{PREVIEW}_'>
  </div>
</div>