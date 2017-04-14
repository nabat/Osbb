<style>
  thead > tr > button.form-control {
    margin-top: 5px
  }
</style>
<form name='form_OSBB_PREVIEW_IMPORT' id='form_OSBB_PREVIEW_IMPORT' method='post' class='form form-horizontal'>
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

  /**
   * DynamicTable is wrapper above DOM <table> that is aware of its headings, rows, columns
   * @constructor
   */
  var DynamicTable = function (id, options) {
    var self = this;
    this.table = jQuery('#' + id);

    if (!this.table.length) {
      alert('Wrong id');
      throw new Error('Wrong table id passed : ' + id);
    }

    this.thead = this.table.find('thead');
    this.tbody = this.table.find('tbody');

    this.rows        = [];
    this.tds_for_row = [];
    this.headings    = [];

    this.renewDOM();

    this.headings_selectable = options.headings;
    if (this.headings_selectable){
      this.setSelectableHeadings(this.headings_selectable);
    }

    var add_new_column_button = jQuery('<button></button>')
        .text('+')
        .addClass('form-control btn-success')
        .on('click', function(e){
          cancelEvent(e);
          self.appendColumn();
        });

    this.headings.last().after(add_new_column_button);
  };

  DynamicTable.prototype.renewDOM        = function () {
    var self = this;

    // Collect headings
    this.headings = this.thead.find('tr').first().find('th');

    // Collect rows
    this.rows = this.tbody.find('tr');

    // Collect columns
    this.rows.each(function (row_num, row) {
      self.tds_for_row[row_num] = jQuery(row).find('td');
    })
  };
  DynamicTable.prototype.getRow          = function (row_num) {
    return this.rows[row_num];
  };
  DynamicTable.prototype.getRows         = function () {
    return this.rows;
  };
  DynamicTable.prototype.getTd           = function (row_num, col_num) {
    return this.tds_for_row[row_num].get(col_num);
  };
  DynamicTable.prototype.getTdsForColumn = function (col_num) {
    // For each table row, retrieve it's *num* td
    return this.rows.map(function () {
      return jQuery(this).find('td').get(col_num);
    });
  };
  DynamicTable.prototype.getHeading      = function (head_num) {
    return this.headings.get(head_num);
  };
  DynamicTable.prototype.getHeadings     = function () {
    return this.headings;
  };
  DynamicTable.prototype.appendRow       = function () {

  };
  DynamicTable.prototype.deleteRow       = function (row_num) {

  };
  DynamicTable.prototype.appendColumn    = function (after_col_) {

    var after_col = isDefined(after_col_) ? after_col_ : (this.headings.length - 1);

    // Append new DropdownSelectable
    var selectableHeading = new DropdownSelectable(after_col + 1, {
      options : this.headings_selectable,
      table   : this
    });

    jQuery('<th/>').html(selectableHeading).insertAfter(this.getHeading(after_col));


    // Append td forEachRow
    this.rows.map(function () {
      var new_input = jQuery('<input/>').addClass('form-control');
      jQuery('<td/>').html(new_input).insertAfter(jQuery(this).find('td').get(after_col));
    });

    this.renewDOM();
  };
  DynamicTable.prototype.deleteColumn    = function (col_num) {
    this.getTdsForColumn(col_num).remove();
    this.getHeading(col_num).remove();
    this.renewDOM();
  };

  DynamicTable.prototype.setSelectableHeadings = function (possible_columns) {
    var self = this;
    // Before creating dropdown, should set active all existing headers
    this.headings.each(function (i, th) {
      var col_name = jQuery(th).text();
      possible_columns.setState(col_name, true);
    });

    this.headings.each(function (i, col) {
      var jcol = jQuery(col);

      var col_name = jcol.text();

      var selectableHeading = new DropdownSelectable(i, {
        options : possible_columns,
        selected: col_name,
        table   : self
      });

      jcol.html(selectableHeading);
    });

    jQuery('input[data-event-onchange=1]').on('input', function () {
      Events.emit('input_change.' + this.id, this.value);
    });
  };

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
      var self = this;
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
        )

      });

      var delete_a  = jQuery('<a/>', {'data-target': '#', 'data-value': 'delete'})
          .css("color", "#fff")
          .text('_{REMOVE}_');
      var delete_li = jQuery('<li>').addClass('bg-red');

      delete_a.on('click', onclick);
      menu.append(delete_li.html(delete_a));

      Events.off('PossibleColumns.column_state_change');
      Events.on('PossibleColumns.column_state_change', function (col_changed) {
        var state    = col_changed.state;
        var col_name = col_changed.column;

        var column_li = menu.find('a[data-value=' + col_name + ']').parent();

        if (col_name === current) {
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

    this.table    = attr.table;
    this.tds      = attr.table.getTdsForColumn(num);
    this.dropdown = jQuery('<div/>', {'class': 'dropdown'});

    var hasValue = this.all_options.hasColumn(this.value);
    this.button  = this.createButtonHTML(hasValue);
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
    this.tds.each(function (i, e) {
      var input = jQuery(e).find('input');

      // Clear previous listener if present
      if (input.data('listens_for')) {
        Events.off('input_change.' + input.data('listens_for'))
      }

      if (value && !input.val()) {
        Events.on('input_change.' + value, input.val.bind(input));
        input.data('listens_for', value)
      }

    });
  };

  DropdownSelectable.prototype.optionClicked = function (clicked) {

    var new_value = clicked.data('value');

    // Tell other dropdowns that previous value is now free
    if (typeof (this.value) !== 'undefined') {
      this.all_options.setState(this.value, false);
    }

    if (new_value === 'delete') {
      this.table.deleteColumn(this.num);
      return true;
    }

    // Tell other dropdowns that value is used now
    this.all_options.setState(new_value, true);

    // Change active

    this.setValue(new_value);

  };

  DropdownSelectable.prototype.dropdownRenew = function (e) {
    var self  = this;
//    this.menu = null;
    this.menu = this.all_options.getView(this.value, function (e) {
      var clicked = jQuery(this);

      // Cancel click on disabled element
      if (clicked.parent().hasClass('disabled')) return cancelEvent(e);

      self.optionClicked(clicked);
    });
  };

  jQuery(function () {
    // All existing columns
    var columns_for_import = JSON.parse('%COLUMNS%');

    var table_id = '%TABLE_ID%';

    var dynamic_table = new DynamicTable(table_id, {
      headings : new PossibleColumns(columns_for_import)
    });

    if (!table_id || !dynamic_table) {
      alert('Import table without id or you passed me wrong id : ' + table_id);
    }

  });
</script>