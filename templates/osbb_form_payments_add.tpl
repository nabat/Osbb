<FORM action='$SELF_URL' METHOD=GET ID='add_user' class='form-horizontal'>
<input type=hidden name='index' value='$index'>
<input type=hidden name='sub' value='%sub%'>
  <div class='box box-theme box-form'>
    <div class='box-header with-border'>
      <div class='col-md-6'>
        <h3 class='box-title'>_{ADD}_</h3>
      </div>  
      <div class='col-md-6'>
        <div class='form-group' style='margin-bottom: 0px;'>%BUILD_SEL%</div>
      </div>
    </div>
    
    <div class='box-body'>
      <div class='form-group'>
        <label class='control-label col-md-3'>Источник платежа</label>
        <div class='col-md-9'>
          <div class='form-group no-margin'>%PTYPE_SEL%</div>
        </div>
      </div>
    
      <div class='form-group'>
        <label class='control-label col-md-3' for='DATE'>_{DATE}_</label>
        <div class='col-md-9'>
          <input id='DATE' name='DATE' value='%DATE%' class='form-control' type='date'>
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3' for='SUM'>_{SUM}_</label>
        <div class='col-md-9'>
          <input id='SUM' name='SUM' value='%SUM%' class='form-control' type='text'>
        </div>
      </div>
      
      <div class='form-group'>
        <label class='control-label col-md-3'>_{USER}_</label>
        <div class='col-md-9'>
          <div class='form-group no-margin'>%USERS_SEL%</div>
        </div>
      </div>
          
    </div>

    
    
    <div class='box-footer'>
      <input type=submit name=add value='_{ADD}_' class='btn btn-primary pull-right'>
    </div>
  </div>
</FORM>