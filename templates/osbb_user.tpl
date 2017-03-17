<form class='form-horizontal' action='$SELF_URL' method='post'>

    <input type=hidden name='index' value='$index'>
    <input type=hidden name='UID' value='$FORM{UID}'>
    <input type=hidden name='step' value='$FORM{step}'>
    <div class='box box-theme box-big-form'>
        <div class='box-header with-border'>
            <h4 class='box-title'>_{DV}_</h4>
            <div class='box-tools pull-right'>
                <button type='button' class='btn btn-box-tool' data-widget='collapse'><i class='fa fa-minus'></i>
                </button>
            </div>
        </div>
        <div class='nav-tabs-custom box-body'>
            <div class='row no-padding'>
                <div class="col-md-12 text-center">
                    %MENU%
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='APARTMENT_AREA'>_{APARTMENT_AREA}_</label>
                <div class='col-md-9'>
                    <input id='APARTMENT_AREA' name='APARTMENT_AREA' value='%APARTMENT_AREA%' placeholder='%APARTMENT_AREA%'
                           class='form-control' type='text'>
                </div>
            </div>


            <div class='box-footer'>
                %BACK_BUTTON%
                <input type=submit name='%ACTION%' value='%LNG_ACTION%' class='btn btn-primary'/>
            </div>
        </div>
    </div>
</form>
