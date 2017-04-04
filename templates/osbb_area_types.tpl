<form class='form-horizontal' action='$SELF_URL' method='post'>
  <input type=hidden name='index' value='$index'>
  <input type=hidden name='ID' value='%ID%'>

  <div class='box box-theme box-big-form'>
    <div class='box-header with-border'>
      <h4 class='box-title'>_{TYPE}_</h4>
      <div class='box-tools pull-right'>
        <button type='button' class='btn btn-box-tool' data-widget='collapse'><i class='fa fa-minus'></i>
        </button>
      </div>
    </div>
    <div class='nav-tabs-custom box-body'>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='NAME_ID'>_{NAME}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%NAME%' required name='NAME' id='NAME_ID'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='OWNERSHIP_TYPE'>_{OWNERSHIP_TYPE}_</label>
        <div class='col-md-9'>
          %OWNERSHIP_TYPE_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='LIVING_AREA_ID'>_{LIVING_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%LIVING_AREA%' name='LIVING_AREA' id='LIVING_AREA_ID'
                 placeholder='0.00'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='TOTAL_AREA_ID'>_{TOTAL_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%TOTAL_AREA%' name='TOTAL_AREA' id='TOTAL_AREA_ID'
                 placeholder='0.00'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='UTILITY_AREA_ID'>_{UTILITY_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%UTILITY_AREA%' name='UTILITY_AREA' id='UTILITY_AREA_ID'
                 placeholder='0.00'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='BALCONY_AREA_ID'>_{BALCONY_AREA}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%BALCONY_AREA%' name='BALCONY_AREA' id='BALCONY_AREA_ID'
                 placeholder='0.00'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='ROOMS_COUNT_ID'>_{ROOMS_COUNT}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' value='%ROOMS_COUNT%' name='ROOMS_COUNT' id='ROOMS_COUNT_ID'
                 placeholder='1'/>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='COMMENTS_ID'>_{COMMENTS}_</label>
        <div class='col-md-9'>
          <textarea class='form-control col-md-9' rows='5' name='COMMENTS' id='COMMENTS_ID'>%COMMENTS%</textarea>
        </div>
      </div>

      <div class='box-footer'>
        %BACK_BUTTON%
        <input type=submit name='%ACTION%' value='%LNG_ACTION%' class='btn btn-primary'/>
      </div>
    </div>
  </div>
</form>
