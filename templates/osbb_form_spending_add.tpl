<FORM action='$SELF_URL' METHOD=GET ID='add_user' class='form-horizontal'>
<input type=hidden name='index' value='$index'>

  <div class='box box-theme box-form'>
    <div class='box-header with-border'>
      <div class='col-md-6'>
        <h3 class='box-title'>_{ADD}_ _{SPENDING}_</h3>
      </div>
    </div>
    <div class='box-body'>
      <div class='form-group'>
        <label class='control-label col-md-3' for='DATE'>_{DATE}_</label>
        <div class='col-md-9'>
          %DATETIMEPICKER%
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3' for='SUM'>_{SUM}_</label>
        <div class='col-md-9'>
          <input id='SUM' name='SUM' value='%SUM%' class='form-control' type='text'>
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3' for='COMMENTS'>_{COMMENTS}_</label>
        <div class='col-md-9'>
          <textarea id='COMMENTS' name='COMMENTS' class='form-control' type='text'>%COMMENTS%</textarea>
        </div>
      </div>
    </div>

    
    
    <div class='box-footer'>
      <input type=submit name=add value='_{ADD}_' class='btn btn-primary'>
    </div>
  </div>
</FORM>