<style>
  .wizard {
    margin: 20px auto;
    background: #fff;
  }

  .wizard .nav-tabs {
    position: relative;
    margin: 40px auto 0;
    border-bottom-color: #e0e0e0;
  }

  .wizard > div.wizard-inner {
    position: relative;
  }

  .wizard div.wizard-list-block {
    border-right: 1px solid #e0e0e0;
    /*padding-bottom: 10px;*/
    margin-bottom: 30px;
  }

  .connecting-line {
    height: 2px;
    background: #e0e0e0;
    position: absolute;
    width: 80%;
    margin: 0 auto;
    left: 0;
    right: 0;
    top: 50%;
    z-index: 1;
  }

  .wizard .nav-tabs > li.active > a, .wizard .nav-tabs > li.active > a:hover, .wizard .nav-tabs > li.active > a:focus {
    color: #555555;
    cursor: default;
    border: 0;
    border-bottom-color: transparent;
  }

  span.round-tab {
    width: 70px;
    height: 70px;
    line-height: 70px;
    display: inline-block;
    border-radius: 100px;
    background: #fff;
    border: 2px solid #e0e0e0;
    z-index: 2;
    position: absolute;
    left: 0;
    text-align: center;
    font-size: 25px;
  }

  span.round-tab i {
    color: #555555;
  }

  .wizard li.active span.round-tab {
    background: #fff;
    border: 2px solid #5bc0de;
  }

  .wizard li.active span.round-tab i {
    color: #5bc0de;
  }

  .wizard li.done span.round-tab i {
    color: #a0d58f;
  }

  span.round-tab:hover {
    color: #333;
    border: 2px solid #333;
  }

  .wizard .nav-tabs > li {
    width: calc(100% / %STEPS_COUNT%);
  }

  .wizard li:after {
    content: ' ';
    position: absolute;
    left: 46%;
    opacity: 0;
    margin: 0 auto;
    bottom: 0;
    border: 5px solid transparent;
    border-bottom-color: #5bc0de;
    transition: 0.1s ease-in-out;
  }

  .wizard li.active:after {
    content: ' ';
    position: absolute;
    left: 46%;
    opacity: 1;
    margin: 0 auto;
    bottom: 0;
    border: 10px solid transparent;
    border-bottom-color: #5bc0de;
  }

  .wizard .nav-tabs > li a {
    width: 70px;
    height: 70px;
    margin: 20px auto;
    border-radius: 100%;
    padding: 0;
  }

  .wizard .nav-tabs > li a:hover {
    background: transparent;
  }

  .wizard .tab-pane {
    position: relative;
    padding: 2% 3% 0;
  }

  .wizard .tab-pane ul.tab-pane-content > li {
    list-style: none;
  }

  .wizard .tab-pane .tab-pane-content {
    min-height: 30vh;
    text-align: left;
    padding: auto 100px;
  }

  .wizard h3 {
    margin-top: 0;
  }

  @media ( max-width: 585px ) {
    .wizard {
      width: 90%;
      height: auto !important;
    }

    span.round-tab {
      font-size: 16px;
      width: 50px;
      height: 50px;
      line-height: 50px;
    }

    .wizard .nav-tabs > li a {
      width: 50px;
      height: 50px;
      line-height: 50px;
    }

    .wizard li.active:after {
      content: ' ';
      position: absolute;
      left: 35%;
    }
  }
</style>

<script type='x-tmpl-mustache' id="osbb_wizard_tab_template">
  <div class='tab-pane {{#is_active}}active{{/is_active}}' role='tabpanel' id='step{{ step_num }}'>

    <div class='row'>
      <div class='col-md-7 text-left'>
        <h3>{{ name }}</h3>
      </div>

      <div class='col-md-5'>
        <ul class='list-inline text-right'>
          {{#is_not_first}}
            <li><button type='button' class='btn btn-default prev-step'>
              <span class='glyphicon glyphicon-chevron-left'></span>
              _{RETURN_BACK}_
            </button></li>
          {{/is_not_first}}
          {{#is_not_last}}
            <li><button type='button' class='btn btn-lg btn-primary next-step'>
              _{DONE}_
              <span class='glyphicon glyphicon-chevron-right'></span>
            </button></li>
          {{/is_not_last}}
          {{#is_last}}
            <li><button type='button' class='btn btn-lg btn-success last-step'>
              _{FINISH}_
              <span class='glyphicon glyphicon-chevron-right'></span>
            </button></li>
          {{/is_last}}
        </ul>
      </div>
    </div>

    <div class='row'>
      <div class='col-md-5 wizard-list-block'>
        <ul class='tab-pane-content'>
          {{#steps}}<li>{{name}}</li>
            {{#items.length}}
              <ul>
              {{#items}}
                  <li>{{name}}</li>
              {{/items}}
              </ul>
            {{/items.length}}
          {{/steps}}
        </ul>
      </div>
      <div class='col-md-7 wizard-hint-block text-left'>
        {{{ hint }}}
      </div>
    </div>

    </div>
  </div>







</script>

<script type='x-tmpl-mustache' id="osbb_wizard_tab_control_template">

  <li role='presentation' data-index='{{ step_num }}' class='{{#is_active}}active{{/is_active}}{{^is_active}}disabled{{/is_active}}'>
    <a href='#step{{ step_num }}' aria-controls='step{{ step_num }}' title='{{ name }}' data-toggle='tab'  role='tab'>
      <span class='round-tab'>
          <i class='glyphicon glyphicon-{{icon}}'></i>
      </span>
    </a>
  </li>





</script>

<div class='row'>
  <div class='wizard'>
    <div class='wizard-inner'>
      <div class='connecting-line'></div>
      <ul class='nav nav-tabs' role='tablist' id='wizard_controls'></ul>
    </div>
    <div class='tab-content' id='wizard_tabs'>
      <div class='clearfix'></div>
    </div>
  </div>
</div>

<script>
  jQuery(document).ready(function () {
    // Parse templates
    var tab_template     = jQuery('#osbb_wizard_tab_template').html();
    var control_template = jQuery('#osbb_wizard_tab_control_template').html();
    Mustache.parse(tab_template);
    Mustache.parse(control_template);

    var controls_wrapper = jQuery('#wizard_controls');
    var tabs_wrapper     = jQuery('#wizard_tabs');

    var steps_count = '%STEPS_COUNT%';
    var steps       = JSON.parse('%STEPS%');

    // Get current active tab
    var aStorage           = new AStorage('localStorage');
    var current_active_tab = +aStorage.getValue('osbb_wizard_active_tab', 0);

    // Build html
    var controls_html = '';
    var tabs_html     = '';

    for (var i = 0; i < steps_count; i++) {
      var step = steps[i];

      // Controls consists of first level items
      controls_html += Mustache.render(control_template, {
        is_active: i === +current_active_tab,
        name     : step.name,
        icon     : step.icon || 'ok',
        step_num : i
      });

      tabs_html += Mustache.render(tab_template, {
        is_active   : i === +current_active_tab,
        step_num    : i,
        name        : step.name,
        steps       : step.items,
        hint        : step.hint,
        is_not_first: i !== 0,
        is_not_last : i !== (steps_count - 1),
        is_last     : i === (steps_count - 1)
      });
    }
    controls_wrapper.html(controls_html);
    tabs_wrapper.html(tabs_html);

    // When we have tabs on page. we can generate checkboxes for lis
    tabs_wrapper.find('ul.tab-pane-content').each(function (i, tab) {

      jQuery(tab).children('li').each(function (j, li_) {
        var li = jQuery(li_);

        var id_for_checkbox = 'wizard_chb_' + i + '_' + j;

        // Generate checkbox
        var checkbox = jQuery('<input/>', {
          type   : 'checkbox',
          'class': 'wizard-checkbox',
          id     : id_for_checkbox
        });
        // Make label from text
        var label    = jQuery('<label/>')
            .html(checkbox[0].outerHTML + li[0].innerHTML);

        // Add checkbox and label
        li.html('<div class="checkbox">' + label[0].outerHTML + '</div>');
      });

    });


    // Wizard tabs controls logic
    initTabControls();

    var ph = new WizardProgressHolder('osbb_wizard_progress');

    // Init checkbox permanent logic
    jQuery('input.wizard-checkbox').on('change', function () {
      var chb = jQuery(this);
      ph.setState('#' + chb.attr('id'), chb.prop('checked'));
    });

  });

  function WizardProgressHolder(storage_key) {
    // Set checkboxes state from storage
    this.storage_key = storage_key;
    this.state       = {};
    var saved        = aStorage.getValue(this.storage_key, null);
    if (saved !== null) {
      this.state = JSON.parse(saved);
    }
    else {
      this.state = {};
    }

    // Set saved checkboxes checked state
    for (var checkbox_identifier in this.state) {
      if (!this.state.hasOwnProperty(checkbox_identifier)) continue;
      jQuery('input' + checkbox_identifier).prop('checked', this.state[checkbox_identifier]);
    }
  }

  WizardProgressHolder.prototype = {
    saveState: function () {
      aStorage.setValue(this.storage_key, JSON.stringify(this.state));
    },
    setState : function (checkbox_identifier, state) {
      this.state[checkbox_identifier] = state;
      this.saveState();
    }
  };

  function initTabControls() {
    //Initialize tooltips
    jQuery('.nav-tabs > li a[title]').tooltip();

    // Unlock previous steps
    jQuery('.wizard .nav-tabs li.active').prevAll().removeClass('disabled').addClass('done');

    jQuery('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
      var _target = jQuery(e.target);
      if (_target.parent().hasClass('disabled')) {
        return false;
      }
    });

    jQuery(".next-step").click(function (e) {
      var _active = jQuery('.wizard .nav-tabs li.active');
      _active.next().removeClass('disabled');
      _active.addClass('done');
      nextTab(_active);

    });
    jQuery(".prev-step").click(function (e) {
      var _active = jQuery('.wizard .nav-tabs li.active');
      _active.removeClass('done');
      prevTab(_active);
    });
  }

  function nextTab(elem) {
    var next_tab = jQuery(elem).next();

    // Save progress
    aStorage.setValue('osbb_wizard_active_tab', next_tab.data('index'));

    // Emulate click
    next_tab.find('a[data-toggle="tab"]').click();
  }

  function prevTab(elem) {
    var prev_tab = jQuery(elem).prev();

    // Save progress
    aStorage.setValue('osbb_wizard_active_tab', prev_tab.data('index'));

    //Emulate click
    prev_tab.find('a[data-toggle="tab"]').click();
  }

</script>