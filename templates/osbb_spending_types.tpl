<form class='form-horizontal' action='$SELF_URL' method='post'>

    <input type=hidden name='index' value='$index'>
    <input type=hidden name='ID' value='%ID%'>
    <div class='box box-theme box-big-form'>
        <div class='box-header with-border'>
            <h4 class='box-title'>_{SPENDING}_ _{TYPES}_</h4>
            <div class='box-tools pull-right'>
                <button type='button' class='btn btn-box-tool' data-widget='collapse'><i class='fa fa-minus'></i>
                </button>
            </div>
        </div>
        <div class='nav-tabs-custom box-body'>
            <div class='form-group'>
                <label class='control-label col-md-3' for='NAME'>_{NAME}_</label>
                <div class='col-md-9'>
                    <input id='NAME' name='NAME' value='%NAME%' placeholder='%NAME%'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                
            </div>
        </div>

        <div class='box-footer'>
            %BACK_BUTTON%
            <input type=submit name='%ACTION%' value='%LNG_ACTION%' class='btn btn-primary'/>
        </div>

    </div>
</form>
