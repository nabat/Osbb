<form class='form-horizontal' action='$SELF_URL' method='post'>

    <input type=hidden name='index' value='$index'>
    <input type=hidden name='UID' value='$FORM{UID}'>
    <input type=hidden name='step' value='$FORM{step}'>
    <div class='box box-theme box-big-form'>
        <div class='box-header with-border'>
            <h4 class='box-title'>_{FLAT}_</h4>
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
                <label class='control-label col-md-3' for='APARTMENT_AREA'>_{LIVING_SPACE}_</label>
                <div class='col-md-9'>
                    <input id='LIVING_SPACE' name='LIVING_SPACE' value='%LIVING_SPACE%' placeholder='%LIVING_SPACE%'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='UTILITY_ROOM'>_{UTILITY_ROOM}_</label>
                <div class='col-md-9'>
                    <input id='UTILITY_ROOM' name='UTILITY_ROOM' value='%UTILITY_ROOM%' placeholder='%UTILITY_ROOM%'
                           class='form-control' type='text'>
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='APARTMENT_AREA'>_{TOTAL_SPACE}_</label>
                <div class='col-md-9'>
                    <input id='APARTMENT_AREA' name='APARTMENT_AREA' value='%APARTMENT_AREA%' placeholder='%APARTMENT_AREA%'
                           class='form-control' type='text' readonly>
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='TYPE'>_{TYPE}_</label>
                <div class='col-md-9'>
                    %SEL_TYPE%
                </div>
            </div>

            <div class='form-group'>
                <label class='control-label col-md-3' for='RENT'>_{RENT}_</label>
                <div class='col-md-3'>
                    <input id='RENT' name='RENT' value='%RENT%' placeholder='%RENT%'
                           class='form-control' type='text' readonly>
                </div>

                <label class='control-label col-md-3' for='APARTMENT_AREA'>_{PRICE}_ (m2)</label>
                <div class='col-md-3'>
                    <input id='PRICE' name='PRICE' value='%PRICE%' placeholder='%PRICE%'
                           class='form-control' type='text' readonly>
                </div>
            </div>

            <div class='box-footer'>
                %BACK_BUTTON%
                <input type=submit name='%ACTION%' value='%LNG_ACTION%' class='btn btn-primary'/>
            </div>
        </div>
    </div>
</form>
