<form class='form-horizontal' action='$SELF_URL' method='post'>
  <input type=hidden name='index' value='$index'>
  <input type=hidden name='build_id' value='%build_id%'>
  <div class='box box-theme box-form'>
    <div class='box-header with-border'>
      <h4 class='box-title'>_{ADDRESS}_</h4>
      <div class='box-tools pull-right'>
        <button type='button' class='btn btn-box-tool' data-widget='collapse'>
          <i class='fa fa-minus'></i>
        </button>
      </div>
    </div>
    <div class='box-body'>
      <div class='form-group'>
        <label class='control-label col-md-2 col-lg-2 col-lg-offset-3' for='DISTRICT_NAME'>_{CITY}_</label>
        <div class='col-md-10 col-lg-4'>
          <input name='DISTRICT_NAME' value='%DISTRICT_NAME%' class='form-control' type='text' %DISABLED%>
        </div>
      </div>
      <div class='form-group'>
        <label class='control-label col-md-2 col-lg-2 col-lg-offset-3' for='STREET_NAME'>_{ADDRESS_STREET}_</label>
        <div class='col-md-10 col-lg-4'>
          <input name='STREET_NAME' value='%STREET_NAME%' class='form-control' type='text'>
        </div>
      </div>
      <div class='form-group'>
        <label class='control-label col-md-2 col-lg-2 col-lg-offset-3' for='NUMBER'>_{ADDRESS_BUILD}_</label>
        <div class='col-md-10 col-lg-4'>
          <input name='NUMBER' value='%NUMBER%' class='form-control' type='text'>
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
      <input type=submit name='%ACTION%' value='%BUTTON%' class='btn btn-primary'/>
    </div>
  </div>
</form>