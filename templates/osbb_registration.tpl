
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

<link href='/styles/default_adm/css/client.css' rel='stylesheet'>
<br>
<FORM action='$SELF_URL' METHOD=POST ID='REGISTRATION' class='form-horizontal'>
<input type=hidden name=module value=Osbb>
<div class='box box-theme box-big-form'>
  <div class='box-header with-border'><h3 class='box-title'>_{REGISTRATION}_</h3></div>
    <div class='box-body'>
    
    <!--div class='form-group'>
      <label class='control-label col-md-3' for='LANGUAGE'>_{LANGUAGE}_</label>
      <div class='col-md-9'>
        %SEL_LANGUAGE%
      </div>
    </div-->
      
    <!--div class='form-group'>
      <label class='control-label required col-md-3' for='LOGIN'>_{LOGIN}_</label>
      <div class='col-md-9'>
        <input id='LOGIN' name='LOGIN' value='%LOGIN%' placeholder='_{LOGIN}_' class='form-control' type='text'>
      </div>
    </div-->

    <div class='form-group'>
      <label class='control-label col-md-3' for='FIO'>_{FIO}_</label>
      <div class='col-md-9'>
        <input id='FIO' name='FIO' value='%FIO%' placeholder='_{FIO}_' class='form-control' type='text'>
      </div>
    </div>

    <div class='form-group'>
      <label class='control-label col-md-3' for='PHONE'>_{PHONE}_</label>
      <div class='col-md-9'>
        <input id='FIO' name='PHONE' value='%PHONE%' placeholder='_{PHONE}_' class='form-control' type='text'>
      </div>
    </div>

    <div class='form-group'>
      <label class='control-label col-md-3' for='EMAIL'>E-MAIL</label>
      <div class='col-md-9'>
        <input id='EMAIL' name='EMAIL' value='%EMAIL%' placeholder='E-mail' class='form-control' type='text'>
      </div>
    </div>
    <div class='form-group text-center'>
      <label class='control-element col-md-12 '>_{RULES}_</label>
      <div class='col-md-12'>
        <textarea cols=60 rows=7 class='form-control' readonly style='resize: none; overflow: auto;'> %_RULES_%</textarea>
      </div>
    </div>
      <div class='checkbox pull-right'>
        <label>
          <input type='checkbox' name='ACCEPT_RULES'>
          <strong>_{ACCEPT}_</strong>
        </label>
      </div>

%CAPTCHA%
  </div>

<div class='box-footer'>
    <input type=submit name=reg value='_{REGISTRATION}_' class='btn btn-primary pull-right'>
</div>


 
</div>
</FORM>