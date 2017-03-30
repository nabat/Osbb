<form name='%FORM_NAME%' id='form_%FORM_NAME%' method='post' class='form form-horizontal'>
  <input type='hidden' name='index' value='$index'/>
  <input type='hidden' name='import' value='1'/>
  <input type='hidden' name='file_columns' value='%FILE_COLUMNS%'/>

  %TABLE%

  <div class='box-footer text-center'>
    <a href='?index=$index' class='btn btn-default'>_{BACK}_</a>
    <input type='submit' class='btn btn-primary' name='import' value='_{IMPORT}_'>
  </div>
</form>


<script>

  var PossibleColumns = function (columns) {
    var self = this;

    this.columns   = columns;
    this.col_names = Object.keys(columns);

    // Holds register for used columns (to prevent duplicates)
    this.registry = {};

    this.setState = function (column, state) {
      this.registry[column] = state;
    };

    this.isColumnActive = function (column) {
      return this.registry.hasOwnProperty(column) && this.registry[column] === true;
    };

    this.hasColumn = function (column) {
      return this.columns.hasOwnProperty(column);
    };

    this.getColumnName = function (column) {
      return this.columns[column];
    };

    this.getView = function (current, onclick) {
      var menu = jQuery('<ul/>', {'class': 'dropdown-menu'});

      this.col_names.forEach(function (col_name) {
        var new_a  = jQuery('<a/>', {'data-target': '#', 'data-value': col_name});
        var new_li = jQuery('<li>');
        if (col_name === current) new_li.addClass('active');

        if (self.hasColumn(col_name) && self.isColumnActive(col_name)) {
          new_li.addClass('disabled');
        }

        new_a.on('click', onclick);

        menu.append(new_li.html(new_a.text(self.getColumnName(col_name))));
      });

      return menu;
    }
  };

  function DropdownSelectable(num, attr) {
    var self = this;

    this.all_options = attr.options;
    this.all_values  = Object.keys(attr.options);
    this.num         = num;
    this.value       = attr.selected;

    this.dropdown = jQuery('<div/>', {'class': 'dropdown'});

    this.dropdown.on('show.bs.dropdown', this.dropdownRenew.bind(this));

    var hasValue = this.all_options.hasColumn(this.value);
    console.log(this.value, hasValue);
    this.button = this.createButtonHTML(hasValue);
    this.renewButtonHTML(this.all_options.getColumnName(this.value));

    // Update button after select was made
    this.dropdown.on('hidden.bs.dropdown', function () {
      if (self.value && self.button.hasClass('btn-warning')) {
        self.button.addClass('btn-primary');
        self.button.removeClass('btn-warning');
      }
    });

    this.dropdownRenew();

    this.dropdown.empty()
        .append(this.button)
        .append(this.menu);

//    this.dropdown.dropdown();

    return this.dropdown;
  }

  DropdownSelectable.prototype.createButtonHTML = function (hasSelected) {
    return jQuery('<button/>', {
      'class'      : 'dropdown-toggle form-control btn-' + (hasSelected ? 'primary' : 'warning'),
      'type'       : 'button',
      'data-toggle': 'dropdown'
    });

  };

  DropdownSelectable.prototype.renewButtonHTML = function (html) {
    if (!html) {
      html = '_{CHOOSE}_';
    }

    this.button.html(html + '<span class="caret"></span>');
  };

  DropdownSelectable.prototype.setValue = function (value) {
    jQuery.data('value', value);

    Events.emit('dropdown_selectable.value_selected', value);

    var text = this.all_options[value];
    this.renewButtonHTML(text);
  };

  DropdownSelectable.prototype.dropdownRenew = function (e) {
    var self = this;

    this.menu = this.all_options.getView(this.value, function () {
      var clicked   = jQuery(this);
      var new_value = clicked.data('value');

      if (self.value !== 'undefined') {
        self.all_options.setState(self.value, false);
      }

      self.all_options.setState(new_value, true);

      self.value = new_value;

      self.renewButtonHTML(self.all_options.getColumnName(self.value))
    });

  };


  jQuery(function () {
    // All existing columns
    var columns_for_import = JSON.parse('%COLUMNS%');

    var table_id = '%TABLE_ID%';

    var table = jQuery('#' + table_id);
    if (!table_id || !table.length) {
      alert('Import table without id or you passed me wrong id');
    }

    // Goal is to add a selector for each table header
    var th = table.find('thead').find('th');

    var possible_column_names = new PossibleColumns(columns_for_import);

    th.each(function (i, col) {
      var jcol = jQuery(col);

      var col_name = jcol.text();

      var selectableHeading = new DropdownSelectable(i, {
        options : possible_column_names,
        selected: col_name
      });

      jcol.html(selectableHeading);
    });

  });
</script>