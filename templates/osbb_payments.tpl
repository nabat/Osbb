<form class='form-horizontal' action='$SELF_URL' method='post'>
  
<input type='hidden' name='index' value='$index'>

<div class='box box-theme box-big-form'>
    <div class='box-header with-border'>
        <h4 class='box-title'>_{PAYMENTS}_</h4>
        <div class='box-tools pull-right'>
            <button type='button' class='btn btn-box-tool' data-widget='collapse'><i class='fa fa-minus'></i>
            </button>
         </div>
    </div>
    <div class='box-body'>
        <div class='form-group'>
            <label class='control-label col-md-3'>_{USER}_</label>
            <div class='col-md-9'>
              %USERS_SELECT%
            </div>
        </div>
        <div class='form-group'>
            <label class='control-label col-md-3 required' for='SUM'>_{SUM}_:</label>
            <div class='col-md-9'>
              <input  id='SUM' name='SUM' value='$FORM{SUM}' required placeholder='$FORM{SUM}' class='form-control'
                   type='text' %AUTOFOCUS%>
            </div>
        </div>
        <div class='form-group'>
          <label class='control-label col-md-3' for='DESCRIBE'>_{DESCRIBE}_:</label>
          <div class='col-md-9'>
            <input id='DESCRIBE' type='text' name='DESCRIBE' value='%DESCRIBE%' class='form-control'>
          </div>
        </div>
        <div class='form-group'>
          <label class='control-label col-md-3' for='PAYMENT_METHOD'>_{PAYMENT_METHOD}_:</label>
          <div class='col-md-9'>
            %SEL_METHOD%
          </div>
        </div>
    </div>
    <div class='box-footer'>
        <input type='submit' class='btn btn-primary' name='add' value='_{ADD}_'>
    </div>
</div>

</form>