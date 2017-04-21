<form method='POST' action='$SELF_URL' class='form-horizontal'>

<input type='hidden' name='index' value='$index'>
<input type='hidden' name='ID' value='%ID%'>


  <div class='box box-theme box-big-form'>
    <div class='box-header with-border'><h4 class='box-title'>_{ADD_TARIF}_</h4></div>
    <div class='box-body'>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{PAYMENT_NAME}_</label>
    <div class='col-md-9'>
      <input type='text' class='form-control' name='NAME' value='%NAME%'>
    </div>
  </div>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{PAYMENT_TYPE}_</label>
    <div class='col-md-9'>
      %PAYMENT_TYPE_SEL%
    </div>
  </div>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{PRICE}_</label>
    <div class='col-md-9'>
      <input type='text' class='form-control' name='PRICE' value='%PRICE%'>
    </div>
  </div>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{DOCUMENT_BASE}_</label>
    <div class='col-md-9'>
      <input type='text' class='form-control' name='DOCUMENT_BASE' value='%DOCUMENT_BASE%'>
    </div>
  </div>

<div class='box-footer'>
  <input type='submit' class='btn btn-primary' name='%ACTION%' value='%ACTION_LNG%'>
</div>

</div>

</form>