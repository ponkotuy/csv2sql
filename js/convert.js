(function() {
  var Table, convertCell, dropEmptyLine, isEmpty, nonEmpty;

  convertCell = function(cell) {
    var ref;
    cell = cell.trim();
    if (cell.length > 0 && ((ref = cell[0]) !== '"' && ref !== "'") && isNaN(cell)) {
      return "'" + cell + "'";
    } else {
      return cell;
    }
  };

  Table = (function() {
    function Table(lines1) {
      this.lines = lines1;
      this.name = this.lines[0];
      this.columns = this.lines[1].split(',');
      this.records = this.lines.slice(2).map(function(l) {
        return l.split(',').map(convertCell);
      });
    }

    Table.prototype.toSQL = function(mani) {
      switch (mani) {
        case 'INSERT':
          return this.createInsert();
        case 'DELETE':
          return this.createDelete();
        case 'SELECT':
          return this.createSelect();
        default:
          return null;
      }
    };

    Table.prototype.linesWithComma = function() {
      return this.records.map(function(line) {
        return "(" + (line.join(', ')) + ")";
      });
    };

    Table.prototype.whereIn = function() {
      return "  WHERE (" + (this.columns.join(', ')) + ") IN\n    " + (this.linesWithComma().join(',\n    ')) + ";";
    };

    Table.prototype.createInsert = function() {
      return "INSERT INTO " + this.name + " (" + (this.columns.join(', ')) + ") VALUES\n  " + (this.linesWithComma().join(',\n  ')) + ";";
    };

    Table.prototype.createDelete = function() {
      return "DELETE FROM " + this.name + "\n" + (this.whereIn());
    };

    Table.prototype.createSelect = function() {
      return "SELECT * FROM " + this.name + "\n" + (this.whereIn());
    };

    return Table;

  })();

  isEmpty = function(str) {
    return str === '';
  };

  nonEmpty = function(str) {
    return str !== '';
  };

  dropEmptyLine = function(xs) {
    return _.dropWhile(xs, isEmpty);
  };

  this.convert = function(mani, csv) {
    var lines, tableLines, tables;
    lines = dropEmptyLine(csv.split('\n'));
    tables = (function() {
      var results;
      results = [];
      while (lines.length > 0) {
        tableLines = _.takeWhile(lines, nonEmpty);
        lines = _.dropWhile(lines, nonEmpty);
        lines = dropEmptyLine(lines);
        results.push(new Table(tableLines));
      }
      return results;
    })();
    return tables.map(function(t) {
      return t.toSQL(mani);
    }).filter(function(s) {
      return s != null;
    }).join('\n\n');
  };

}).call(this);
