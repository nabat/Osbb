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


  <br>

  <div class='box box-theme box-big-form'>
    <div class='box-header with-border'>
      <div class='row'>
        <div class='col-md-8'>
          <h3 class='box-title'>_{REGISTRATION}_ _{OSBB}_</h3>
        </div>
        <label class='control-label col-md-2' for='LANGUAGE'>_{LANGUAGE}_</label>
        <div class='col-md-2'>
          <div class='form-group no-margin pull-right'>
            %SEL_LANGUAGE%
          </div>
        </div>
      </div>
    </div>
    <div class='box-body'>

      <!--div class='form-group'>
        <label class='control-label required col-md-3' for='LOGIN'>_{LOGIN}_</label>
        <div class='col-md-9'>
          <input id='LOGIN' name='LOGIN' value='%LOGIN%' placeholder='_{LOGIN}_' class='form-control' type='text'>
        </div>
      </div-->
      <div class='row'>
        <div class='col-md-12 col-lg-6'>
          <div class='form-group'>
            <label class='control-label col-md-3' for='FIO'>_{FIO}_</label>
            <div class='col-md-9'>
              <input id='FIO' name='FIO' value='%FIO%' placeholder='Приклад : Сидоренко Іван Петрович ' class='form-control' type='text'>
            </div>
          </div>

          <div class='form-group'>
            <label class='control-label col-md-3' for='PHONE'>_{PHONE}_</label>
            <div class='col-md-9'>
              <input id='PHONE' name='PHONE' value='%PHONE%' placeholder='Приклад : 0501112233' class='form-control' type='text'>
            </div>
          </div>

          <div class='form-group'>
            <label class='control-label col-md-3' for='EMAIL'>E-MAIL</label>
            <div class='col-md-9'>
              <input id='EMAIL' name='EMAIL' value='%EMAIL%' placeholder='Приклад : mymail@mail.com' class='form-control'
                     type='text'>
            </div>
          </div>
        </div>

        <div class='col-md-12 col-lg-6'>
          <div class='form-group'>
            <label class='control-label col-md-3' for='CITY'>_{CITY}_</label>
            <div class='col-md-9'>
              <input id='CITY' name='CITY' value='%CITY%' placeholder='Приклад : Київ' class='form-control' type='text'>
            </div>
          </div>

          <div class='form-group'>
            <label class='control-label col-md-3' for='ADDRESS_STREET'>_{ADDRESS_STREET}_</label>
            <div class='col-md-9'>
              <input id='ADDRESS_STREET' name='ADDRESS_STREET' value='%ADDRESS_STREET%' placeholder='Приклад : Хрещатик'
                     class='form-control' type='text'>
            </div>
          </div>

          <div class='form-group'>
            <label class='control-label col-md-3' for='ADDRESS_BUILD'>_{ADDRESS_BUILD}_</label>
            <div class='col-md-9'>
              <input id='ADDRESS_BUILD' name='ADDRESS_BUILD' value='%ADDRESS_BUILD%' placeholder='Приклад : 25'
                     class='form-control' type='text'>
              <p class='help-block'>
                <small>Вкажіть адресу вашого будинку або одного з будинків (якщо їх декілька).</small>
              </p>
            </div>
          </div>
        </div>
      </div>
      <div class='form-group'>
        <label class='control-element col-md-12 '>_{RULES}_</label>
        <div class='col-md-12'>
          <div class="well">
            %OSBB_RULES%
          </div>
        </div>
      </div>
      <div class='checkbox'>
        <label>
          <input type='checkbox' name='ACCEPT_RULES'>
          <strong>_{ACCEPT}_ <span class='text-lowercase'>_{RULES}_</span></strong>
        </label>
      </div>
      <div class='col-md-6'>
        %CAPTCHA%
      </div>
    </div>

    <div class='box-footer'>
      %FB_INFO%
      <input type=submit name=reg value='_{REGISTRATION}_' class='btn btn-success'>      
    </div>


  </div>
</FORM>