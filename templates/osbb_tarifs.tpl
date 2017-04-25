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
    <label class='col-md-3 control-label'>_{UNIT}_</label>
    <div class='col-md-9'>
      %UNITS_SEL%
    </div>
  </div>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{DOCUMENT_BASE}_</label>
    <div class='col-md-9'>
      <input type='text' class='form-control' name='DOCUMENT_BASE' value='%DOCUMENT_BASE%'>
    </div>
  </div>

 <div class='form-group'>
    <label class='col-lg-3 col-md-3 control-label'>_{COME_INTO_FORCE}_</label>
    <div class='col-lg-3 col-md-3'>
      <input id="START_DATE" name="START_DATE" value="%START_DATE%" placeholder="0000-00-00" class="form-control datepicker" rel="tcal" type="text">
    </div>
  </div>

 <div class='form-group'>
    <label class='col-lg-3 col-md-3 control-label'>_{PRICE}_</label>
    <div class='col-lg-2 col-md-2'>
      <input type='text' class='form-control' name='PRICE' value='%PRICE%'>
    </div>
  </div>

  <div class='form-group'>
    <label class='col-md-3 control-label'>_{SET_TARIF_TO_ALL}_</label>
    <div class='col-md-9'>
      <input name="SET_ALL" value="1" %SET_ALL_CHEK% type="checkbox">
    </div>
  </div>

<div class='box-footer'>
  <input type='submit' class='btn btn-primary' name='%ACTION%' value='%ACTION_LNG%'>
</div>

</div>

</form>