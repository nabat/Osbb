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
    bottom: 0px;
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
    bottom: 0px;
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
    padding-top: 50px;
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
    <h3>{{ name }}</h3>
    <ul class='tab-pane-content'>
    {{#steps}}
    <li>{{.}}</li>
    {{/steps}}
    </ul>
    <ul class='list-inline pull-right'>
      {{#is_not_first}}
        <li>
          <button type='button' class='btn btn-default prev-step'></button>
        </li>
      {{/is_not_first}}
      {{#is_not_last}}
        <li>
          <button type='button' class='btn btn-primary next-step'></button>
        </li>
      {{/is_not_last}}
      {{#is_last}}
        <li>
          <button type='button' class='btn btn-primary last-step'></button>
        </li>
      {{/is_last}}
    </ul>
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
  <section>
    <div class='wizard'>
      <div class='wizard-inner'>
        <div class='connecting-line'></div>
        <ul class='nav nav-tabs' role='tablist' id='wizard_controls'></ul>
      </div>
      <form role='form'>
        <div class='tab-content' id='wizard_tabs'>
          <div class='clearfix'></div>
        </div>
      </form>
    </div>
  </section>
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

    console.log(current_active_tab);

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
        is_not_first: i !== 0,
        is_not_last : i !== (steps_count - 1),
        is_last     : i === (steps_count - 1)
      });
    }
    controls_wrapper.html(controls_html);
    tabs_wrapper.html(tabs_html);

    // Translate buttons ( Mustache kills utf8 ? )
    jQuery('button.btn.prev-step').text('_{RETURN_BACK}_');
    jQuery('button.btn.next-step').text('_{DONE}_');
    jQuery('button.btn.last-step').text('_{FINISH}_');


    //Initialize tooltips
    jQuery('.nav-tabs > li a[title]').tooltip();

    //Wizard controls logic
    jQuery('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
      var _target = jQuery(e.target);
      if (_target.parent().hasClass('disabled')) {
        return false;
      }
    });

    jQuery(".next-step").click(function (e) {
      var _active = jQuery('.wizard .nav-tabs li.active');
      _active.next().removeClass('disabled');
      nextTab(_active);

    });
    jQuery(".prev-step").click(function (e) {
      var _active = jQuery('.wizard .nav-tabs li.active');
      prevTab(_active);
    });
  });

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