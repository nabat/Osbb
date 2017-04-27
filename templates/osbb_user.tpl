<div class='box box-theme box-big-form'>
  <div class='box-header with-border'><h4 class='box-title'>_{OSBB}_ _{FLAT}_</h4></div>
  <div class='box-body'>
    <form name='OSBB_SINGLE_USER_ADD' id='form_OSBB_SINGLE_USER_ADD' method='post' class='form form-horizontal'>
      <input type='hidden' name='index' value='$index'/>
      <input type='hidden' name='UID' value='%UID%'/>
      <input type='hidden' name='%SUBMIT_BTN_ACTION%' value='1'/>
      <input type=hidden name='step' value='$FORM{step}'>

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
        <label class='control-label col-md-3' for='TOTAL_AREA_ID'>_{TOTAL_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%TOTAL_AREA%' name='TOTAL_AREA' id='TOTAL_AREA_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='LIVING_AREA_ID'>_{LIVING_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%LIVING_AREA%' name='LIVING_AREA' id='LIVING_AREA_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='UTILITY_AREA_ID'>_{UTILITY_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%UTILITY_AREA%' name='UTILITY_AREA' id='UTILITY_AREA_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='BALCONY_AREA_ID'>_{BALCONY_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%BALCONY_AREA%' name='BALCONY_AREA' id='BALCONY_AREA_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='USEFUL_AREA_ID'>_{USEFUL_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%USEFUL_AREA%' name='USEFUL_AREA' id='USEFUL_AREA_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='ROOMS_COUNT_ID'>_{ROOMS_COUNT}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%ROOMS_COUNT%' name='ROOMS_COUNT' id='ROOMS_COUNT_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='PEOPLE_COUNT_ID'>_{PEOPLE_COUNT}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%PEOPLE_COUNT%' name='PEOPLE_COUNT' id='PEOPLE_COUNT_ID'/>
        </div>
      </div>
    </form>

  </div>
  <div class='box-footer'>
    %BACK_BUTTON%
    <input type='submit' form='form_OSBB_SINGLE_USER_ADD' class='btn btn-primary' name='submit'
           value='%SUBMIT_BTN_NAME%'>
  </div>
</div>