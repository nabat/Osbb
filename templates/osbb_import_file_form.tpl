<div class='box box-theme box-form'>
  <div class='box-header with-border'><h4 class='box-title'>_{IMPORT}_</h4></div>
  <div class='box-body'>
    <form name='OSBB_IMPORT_FILE' id='form_OSBB_IMPORT_FILE' method='post' enctype='multipart/form-data' class='form form-horizontal'>
      <input type='hidden' name='index' value='$index' />
      <input type='hidden' name='import' value='1' />

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_FORMAT'>_{TYPE}_</label>
        <div class='col-md-9'>
          %FILE_FORMAT_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_ID'>_{FILE}_</label>
        <div class='col-md-9'>
          <input type='file' class='form-control' required='required' name='FILE'  id='FILE_ID'  />
        </div>
      </div>

      <div class='form-group' style='display: none;'>
        <label class='control-label col-md-3 required' for='FILE_ENCODING'>_{ENCODE}_</label>
        <div class='col-md-9'>
          %FILE_ENCODING_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='FILE_ID'>_{ADDRESS}_</label>
        <div class='col-md-9'>
          %LOCATION_ID_SELECT%
        </div>
      </div>


    </form>

  </div>
  <div class='box-footer'>
    <input type='submit' id='form_submit' form='form_OSBB_IMPORT_FILE' class='btn btn-primary' name='preview' value='_{PREVIEW}_'>
  </div>
</div>

<script>
  jQuery(function () {
    var file_input = jQuery('#FILE_ID');
    var submit_btn = jQuery('#form_submit');

    file_input.on('change', function () {
      console.log('file was added');

      var files = file_input[0].files;

      var data = {
        qindex : '$index',
        header : 2,
        'import' : 1,
        analyze_file : 1
      };

      // Send file for analyze
      for (var i = 0; i < files.length; i++) {
        var fd = new FormData();
        fd.append('file', files[i]);
        fd.append('filename', files[i].name);

        for (var key in data){
          fd.append(key, data[key]);
        }

        sendFileToServer(fd, status);

        submit_btn.addClass('disabled');
        submit_btn.prop('disabled', true);
      }
    });
  });

  function sendFileToServer(formData, status) {
    var uploadURL = "/admin/index.cgi"; //Upload URL
    //Extra Data.
    var jqXHR     = jQuery.ajax({
      url        : uploadURL,
      type       : "POST",
      contentType: false,
      processData: false,
      cache      : false,
      data       : formData,
      success    : handleResponse
    });
  }

  function handleResponse(response) {
    var submit_btn      = jQuery('#form_submit');
    var encoding_select = jQuery('select#FILE_ENCODING');
    var file_input      = jQuery('#FILE_ID');

    var data = {};
    try {
      data = JSON.parse(response);
    }
    catch (Error) {
      aTooltip.displayError(Error, 3000);
      submit_btn.removeClass('disabled');
      submit_btn.prop('disabled', false);
    }

    // Handle file extension
    if (data && data['result'] === 'error' && data['message']) {
      aTooltip.displayError(data['message'], 3000);
      file_input.val('');
      if (!/safari/i.test(navigator.userAgent)) {
        file_input.attr('type', '');
        file_input.attr('type', 'file');
      }

      return false;
    }  // Handle encoding

    if (data && data['result'] === 'ok') {
      var encoding = data['encoding'];

      console.log(encoding);

      switch (encoding) {
        case 'UTF-8' :
          break;
        default:
          renewChosenValue(encoding_select, encoding);
          break;
      }

      submit_btn.removeClass('disabled');
      submit_btn.prop('disabled', false);
    }
    else {
      console.log('error');
      encoding_select.parents('div.form-group').first().css({'display': 'block'});
      submit_btn.removeClass('disabled');
      submit_btn.prop('disabled', false);
    }

  }

</script>