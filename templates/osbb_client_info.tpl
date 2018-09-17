<div class='box box-theme box-form'>
  <div class='box-header with-border box-big-form'><h4 class='box-title'>%PANEL_HEADING%</h4></div>
  <div class='box-body'>
    <form name='OSBB_SINGLE_USER_ADD' id='form_OSBB_SINGLE_USER_ADD' method='post' class='form form-horizontal'>
      <input type='hidden' name='index' value='$index' />
      <input type='hidden' name='%SUBMIT_BTN_ACTION%' value='1' />
      <input type='hidden' name='UID' value='%UID%' />

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='TYPE'>_{TYPE}_</label>
        <div class='col-md-9'>
          %TYPE_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='OWNERSHIP_TYPE'>_{OWNERSHIP_TYPE}_</label>
        <div class='col-md-9'>
          %OWNERSHIP_TYPE_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{TOTAL_AREA}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%TOTAL_AREA%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{LIVING_AREA}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%LIVING_AREA%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{UTILITY_AREA}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%UTILITY_AREA%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{BALCONY_AREA}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%BALCONY_AREA%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{USEFUL_AREA}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%USEFUL_AREA%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{ROOMS_COUNT}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%ROOMS_COUNT%</p>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3'>_{PEOPLE_COUNT}_</label>
        <div class='col-md-9'>
          <p class='form-control-static'>%PEOPLE_COUNT%</p>
        </div>
      </div>
    </form>

  </div>
  <div class='box-footer'>
    <input type='submit' form='form_OSBB_SINGLE_USER_ADD' class='btn btn-primary' name='submit' value='%SUBMIT_BTN_NAME%'>
  </div>
</div>
