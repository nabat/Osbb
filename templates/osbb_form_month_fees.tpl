<form action='$SELF_URL' METHOD=POST>

<input type='hidden' name='index' value='$index'>

<div class='box box-form box-primary form-horizontal'>
  
<div class='box-header with-border'>_{FILTER}_</div>

<div class='box-body'>
  <div class='form-group'>
    <label class='col-md-3 control-label'>_{MONTH}_</label>
    <div class='col-md-9 no-margin'>%MONTH_SELECT%</div>
  </div>
  <div class='form-group'>
    <label class='col-md-3 control-label'>_{YEAR}_</label>
    <div class='col-md-9 no-margin'>%YEAR_SELECT%</div>
  </div>
</div>

<div class='box-footer'>
  <input type='submit' class='btn btn-primary' value='_{SHOW}_' name='show'>
</div>

</div>

%TABLE%
<div class='box-footer'>
  <input type='submit' class='btn btn-primary' value='_{ADD}_' name='add'>
</div>

</form>