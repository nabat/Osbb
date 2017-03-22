<form class='form-horizontal' action='$SELF_URL' method='post'>

    <input type=hidden name='index' value='$index'>
    <input type=hidden name='ID' value='%ID%'>
    <div class='box box-theme box-big-form'>
        <div class='box-header with-border'>
            <h4 class='box-title'>_{TYPE}_</h4>
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
                <label class='control-label col-md-12' for='LIVING_SPACE'>_{PRICE}_ (m2)</label>
            </div>


            <div class='form-group'>
                <label class='control-label col-md-3' for='LIVING_SPACE'>_{LIVING_SPACE}_</label>
                <div class='col-md-9'>
                    <input id='LIVING_SPACE' name='LIVING_SPACE' value='%LIVING_SPACE%' placeholder='0.00'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='UTILITY_ROOM'>_{UTILITY_ROOM}_</label>
                <div class='col-md-9'>
                    <input id='UTILITY_ROOM' name='UTILITY_ROOM' value='%UTILITY_ROOM%' placeholder='0.00'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for=TOTAL_SPACE'>_{TOTAL_SPACE}_</label>
                <div class='col-md-9'>
                    <input id='TOTAL_SPACE' name='TOTAL_SPACE' value='%TOTAL_SPACE%' placeholder='0.00'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                <div class='col-md-12'>
                    <textarea name='COMMENTS' cols='10' rows='4' class='form-control'>%COMMENTS%</textarea>
                </div>
            </div>

            <div class='box-footer'>
                %BACK_BUTTON%
                <input type=submit name='%ACTION%' value='%LNG_ACTION%' class='btn btn-primary'/>
            </div>
        </div>
    </div>
</form>
