<FORM action='$SELF_URL' METHOD=GET ID='add_user' class='form-horizontal'>
<input type=hidden name='index' value='$index'>
<input type=hidden name='usr' value=%usr%>
<input type=hidden name='LOCATION_ID' value='%LOCATION_ID%'>
  <div class='box box-theme box-form'>
    <div class='box-header with-border'>
      <div class='col-md-6'>
        <h3 class='box-title'>%BUTTON%</h3>
      </div>  
    </div>
    
    <div class='box-body'>
      <div class='form-group'>
        <label class='control-label col-md-3' for='ADDRESS_FLAT'>_{ADDRESS_FLAT}_</label>
        <div class='col-md-9'>
          <input id='ADDRESS_FLAT' name='ADDRESS_FLAT' value='%ADDRESS_FLAT%' class='form-control' type='text'>
        </div>
      </div>
          
      <div class='form-group'>
        <label class='control-label col-md-3' for='FIO'>_{FIO}_</label>
        <div class='col-md-9'>
          <input id='FIO' name='FIO' value='%FIO%' class='form-control' type='text'>
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3' for='PHONE'>_{PHONE}_</label>
        <div class='col-md-9'>
          <input id='PHONE' name='PHONE' value='%PHONE%' class='form-control' type='text'>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='EMAIL'>_{EMAIL}_</label>
        <div class='col-md-9'>
          <input id='EMAIL' name='EMAIL' value='%EMAIL%' class='form-control' type='text'>
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3' for='LIVING_AREA'>_{LIVING_AREA}_</label>
        <div class='col-md-9'>
          <input id='LIVING_AREA' name='LIVING_AREA' value='%LIVING_AREA%' class='form-control' type='number' step='0.01'>
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3' for='PEOPLE_COUNT'>_{PEOPLE_COUNT}_</label>
        <div class='col-md-9'>
          <input id='PEOPLE_COUNT' name='PEOPLE_COUNT' value='%PEOPLE_COUNT%' class='form-control' type='text'>
        </div>
      </div>
    </div>

    <div class="box collapsed-box" style='margin-bottom: 0px; border-top-width: 1px;'>
      <div class="box-header with-border">
        <h3 class="box-title">_{EXTRA_ABBR}_. _{FIELDS}_</h3>
        <div class="box-tools pull-right">
          <button type="button" class="btn btn-default btn-xs" data-widget="collapse">
            <i class="fa fa-plus"></i>
          </button>
        </div>
      </div>
      <div class="box-body">
          %EXTRA_FIELDS%
      </div>
    </div>
    
    <div class='box-footer'>
      <input type=submit name='%ACTION%' value='%BUTTON%' class='btn btn-primary'>
    </div>
  </div>
</FORM>
