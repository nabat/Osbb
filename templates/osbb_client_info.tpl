    <div class='box box-theme box-big-form'>
        <div class='box-header with-border'>
            <h4 class='box-title'>_{RENT}_</h4>
            <div class='box-tools pull-right'>
                <button type='button' class='btn btn-box-tool' data-widget='collapse'><i class='fa fa-minus'></i>
                </button>
            </div>
        </div>
        <div class='box-body'>

            <ul class='list-group list-group-unbordered'>
                <li class='list-group-item'>
                    <b>_{LIVING_SPACE}_</b> <a class='pull-right'>%LIVING_SPACE%</a>
                </li>
                <li class='list-group-item'>
                    <b>_{UTILITY_ROOM}_</b> <a class='pull-right'>%UTILITY_ROOM%</a>
                </li>
                <li class='list-group-item'>
                    <b>_{APARTMENT_AREA}_</b> <a class='pull-right'>%APARTMENT_AREA%</a>
                </li>
                <li class='list-group-item'>
                    <b>_{TYPE}_</b> <a class='pull-right'>%TYPE%</a>
                </li>
            </ul>

            <div class='form-group'>
                <label class='control-label col-md-3' for='RENT'>_{RENT}_</label>
                <div class='col-md-3'>
                    <input id='RENT' name='RENT' value='%RENT%' placeholder='%RENT%'
                           class='form-control' type='text' readonly>
                </div>

                <label class='control-label col-md-3' for='PRICE'>_{PRICE}_ (m2)</label>
                <div class='col-md-3'>
                    <input id='PRICE' name='PRICE' value='%PRICE%' placeholder='%PRICE%'
                           class='form-control' type='text' readonly>
                </div>
            </div>
        </div>
    </div>

