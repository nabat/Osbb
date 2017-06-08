</div></div>
<script type='text/javascript'>
  function selectLanguage() {
    var sLanguage = jQuery('#language').val() || '';
    var sLocation = '$SELF_URL?DOMAIN_ID=$FORM{DOMAIN_ID}&language=' + sLanguage;
    location.replace(sLocation);
  }
  function set_referrer() {
    document.getElementById('REFERER').value = location.href;
  }
</script>
<script src='https://www.google.com/recaptcha/api.js'></script>

<link href='/styles/default_adm/css/client.css' rel='stylesheet'>

<FORM action='$SELF_URL' METHOD=POST ID='REGISTRATION' class='form-horizontal'>
  <input type='hidden' name='module' value='Osbb'>
  <input type='hidden' name='user_registration' value='1'>


  <br>


  <div class='box box-theme box-form'>
    <div class='box-header with-border'>
      <div class='row'>
        <div class='col-md-6'>
          <h3 class='box-title'>_{REGISTRATION}_</h3>
        </div>
        <label class='control-label col-md-2' for='LANGUAGE'>_{LANGUAGE}_</label>
        <div class='col-md-4'>
          <div class='form-group no-margin pull-right'>
            %SEL_LANGUAGE%
          </div>
        </div>
      </div>
    </div>
    <div class='box-body'>
      <div class='row'>
        <div class='col-md-12'>
          <div class="form-group">
            <input id='FIO' name='FIO' value='%FIO%' placeholder='_{FIO}_' class='form-control' type='text'>
          </div>
          <div class="form-group">
            <input id='PHONE' name='PHONE' value='%PHONE%' placeholder='_{PHONE}_ (0501112233)' class='form-control' type='text'>
            </div>
          <div class="form-group">
            <input id='EMAIL' name='EMAIL' value='%EMAIL%' placeholder='E-MAIL' class='form-control' type='text'>
          </div>
        </div>
      </div>
      <div class='col-md-6'>
        %CAPTCHA%
      </div>
    </div>

    <div class='box-footer'>
      <input type=submit name=reg value='_{REGISTRATION}_' class='btn btn-success btn-block'>
      %FB_INFO_BLOCK%      
    </div>


  </div>
</FORM>