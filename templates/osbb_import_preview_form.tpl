<div class="row">
  <form action='$SELF_URL'>
    <input type='hidden' name='index' value='$index'>
    <input type='hidden' name='import' value='1'>
    <a href='?index=$index' class='btn btn-default'>_{BACK}_</a>
    <input type='submit' class='btn btn-primary' name='import' value='_{IMPORT}_'>
  </form>
</div>

<script>

  function DropdownSelectable(num, attr) {
    var self = this;

    this.all_options = attr.options;
    this.all_values  = Object.keys(attr.options);
    this.num         = num;
    this.value       = attr.selected;

    this.dropdown = jQuery('<div/>', {'class': 'dropdown'});
    this.menu     = jQuery('<ul/>', {'class': 'dropdown-menu'});

//    this.dropdown.on('show.bs.dropdown', this.dropdownRenew.bind(this));
    // Dropdown menu
    this.all_values.forEach(function (e) {
      var new_a = jQuery('<a/>', {'data-target': '#', 'data-value': e})
          .text(self.all_options[e]);

      new_a.on('click', function (e) {
//        cancelEvent(e);
        var _a = jQuery(this);
        self.setValue(_a.data('value'));
//        _a.addClass('active');
//        self.dropdown.dropdown('toggle');
      });

      self.menu.append(jQuery('<li>').html(new_a));
    });

    this.button = this.createButtonHTML(typeof(this.all_options[this.value]) !== undefined);
    this.renewButtonHTML(this.all_options[this.value]);

    this.dropdown.empty()
        .append(this.button)
        .append(this.menu);

    return this.dropdown;
  }

  DropdownSelectable.prototype.createButtonHTML = function (hasSelected) {
    return jQuery('<button/>', {
      'class'      : 'dropdown-toggle form-control btn-' + (hasSelected ? 'primary' : 'warning'),
      'type'       : 'button',
      'data-toggle': 'dropdown'
    });

  };

  DropdownSelectable.prototype.renewButtonHTML  = function (html) {
    if (!html) {
      html = '_{CHOOSE}_';
      if (this.button.hasClass('btn-primary')) {
        this.button.addClass('btn-warning');
        this.button.removeClass('btn-primary');
      }
    }

    if (this.button.hasClass('btn-warning')) {
      this.button.addClass('btn-primary');
      this.button.removeClass('btn-warning');
    }

    this.button.html(html + '<span class="caret"></span>');
  };

  DropdownSelectable.prototype.setValue         = function (value) {
    var text = this.all_options[value];
    this.renewButtonHTML(text);
    jQuery.data('value', value);
  };

  DropdownSelectable.prototype.dropdownRenew = function () {

  };


  jQuery(function () {
    // All existing columns
    var columns_for_import = JSON.parse('%COLUMNS%');

    // Current accepted table headings
    var headings = JSON.parse('%HEADINGS%');

    var table_id = '%TABLE_ID%';

    var table = jQuery('#' + table_id);
    if (!table_id || !table.length) {
      alert('Import table without id or you passed me wrong id');
    }

    // Goal is to add a selector for each table header
    var th = table.find('thead').find('th');

    console.log(th);

    th.each(function (i, col) {
      var jcol = jQuery(col);

      var col_name = jcol.text();
      console.log(col_name, columns_for_import[col_name]);

      var selectableHeading = new DropdownSelectable(i, {
        options : columns_for_import,
        selected: (typeof (columns_for_import[col_name]) !== 'undefined') ? col_name : false
      });

      jcol.html(selectableHeading);
    });

  });
</script>