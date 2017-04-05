<form name='%FORM_NAME%' id='form_%FORM_NAME%' method='post' class='form form-horizontal'>
  <input type='hidden' name='index' value='$index'/>
  <input type='hidden' name='import' value='1'/>
  <input type='hidden' name='file_columns' value='%FILE_COLUMNS%'/>

  <div class='box box-theme box-form'>
    <div class='box-body'>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='LOCATION_ID'>_{ADDRESS}_</label>
        <div class='col-md-9'>
          %LOCATION_ID_SELECT%
        </div>
      </div>

      <div class='form-group'>
        <label class='control-label col-md-3 required' for='PASSWORD_ID'>_{PASSWD}_</label>
        <div class='col-md-9'>
          <input type='text' class='form-control' name='PASSWORD' id='password' value='%PASSWORD%'
                 data-event-onchange='1'>
        </div>
      </div>

    </div>
  </div>


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
      Events.emit('PossibleColumns.column_state_change', {column: column, state: state});
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

        if (col_name === current) {
          new_li.addClass('active');
        }
        else if (self.registry[col_name] === true) {
          new_li.addClass('disabled');
        }

        new_a.on('click', onclick);

        menu.append(
            new_li.html(
                new_a.text(self.getColumnName(col_name))
            )
        );

      });

      Events.off('PossibleColumns.column_state_change');
      Events.on('PossibleColumns.column_state_change', function (col_changed) {
        var state    = col_changed.state;
        var col_name = col_changed.column;

        var column_li = menu.find('a[data-value=' + col_name + ']').parent();

        if (col_name === current){
          state
              ? column_li.addClass('active')
              : column_li.removeClass('active');
        }

        state
            ? column_li.addClass('disabled')
            : column_li.removeClass('disabled');

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

    // For each table row, retrieve it's *num* td
    this.trs = attr.table.find('tbody').find('tr');
    this.tds = this.trs.map(function () {
      return jQuery(this).find('td').get(num);
    });

    this.dropdown = jQuery('<div/>', {'class': 'dropdown'});

    var hasValue = this.all_options.hasColumn(this.value);

    this.button = this.createButtonHTML(hasValue);
    this.setValue(this.value);

    // Update button after select was made
    this.dropdown.on('hidden.bs.dropdown', function () {
      if (self.all_options.hasColumn(self.value) && self.button.hasClass('btn-warning')) {
        self.button.addClass('btn-primary');
        self.button.removeClass('btn-warning');
      }
    });

    // Writes this.menu as side effect
    this.dropdownRenew();

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

  DropdownSelectable.prototype.renewButtonHTML = function (html) {
    if (!html) {
      html = '_{CHOOSE}_';
    }

    this.button.html(html + '<span class="caret"></span>');
  };

  DropdownSelectable.prototype.setValue = function (value) {
    this.value = value;
    this.renewButtonHTML(this.all_options.getColumnName(value));

    // Set listeners for table inputs
    this.tds.each(function(i, e){
      var input = jQuery(e).find('input');

      // Clear previous listener if present
      if (input.data('listens_for')){
        Events.off('input_change.' + input.data('listens_for'))
      }

      if (value &&! input.val()){
        Events.on('input_change.' + value, input.val.bind(input));
        input.data('listens_for', value)
      }

    });
  };

  DropdownSelectable.prototype.dropdownRenew = function (e) {
    var self = this;

    this.menu = null;
    this.menu = this.all_options.getView(this.value, function (e) {
      var clicked = jQuery(this);

      // Cancel click on disabled element
      if (clicked.parent().hasClass('disabled')) return cancelEvent(e);

      var new_value = clicked.data('value');

      // Tell other dropdowns that previous value is now free
      if (typeof (self.value) !== 'undefined') {
        self.all_options.setState(self.value, false);
      }

      // Tell other dropdowns that value is used now
      self.all_options.setState(new_value, true);

      // Change active

      self.setValue(new_value);
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

    // Before creating dropdown, should set active all existing headers
    th.each(function (i, th) {
      var col_name = jQuery(th).text();
      possible_column_names.setState(col_name, true);
    });

    th.each(function (i, col) {
      var jcol = jQuery(col);

      var col_name = jcol.text();

      var selectableHeading = new DropdownSelectable(i, {
        options : possible_column_names,
        selected: col_name,
        table   : table
      });

      jcol.html(selectableHeading);
    });

    jQuery('input[data-event-onchange=1]').on('input', function () {
      Events.emit('input_change.' + this.id, this.value);
    });

  });
</script>