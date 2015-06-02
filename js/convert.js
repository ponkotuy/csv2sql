(function() {
  var Table, convertCell, decideSeparator, dropEmptyLine, isEmpty, matchCount, nonEmpty;

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
    function Table(lines1, sep1) {
      this.lines = lines1;
      this.sep = sep1;
      this.name = this.lines[0];
      this.columns = this.lines[1].split(this.sep);
      console.log(this.sep);
      this.records = this.lines.slice(2).map((function(_this) {
        return function(l) {
          return l.split(_this.sep).map(convertCell);
        };
      })(this));
    }

    Table.prototype.toSQL = function(mani, detail) {
      switch (mani) {
        case 'INSERT':
          return createInsert(detail, this);
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
      if (this.columns.length === 1) {
        return "  WHERE " + this.columns[0] + " IN (" + (this.records.concat().join(', ')) + ")";
      } else {
        return "  WHERE (" + (this.columns.join(', ')) + ") IN (\n    " + (this.linesWithComma().join(',\n    ')) + ")";
      }
    };

    Table.prototype.createDelete = function() {
      return "DELETE FROM " + this.name + "\n" + (this.whereIn()) + ";";
    };

    Table.prototype.createSelect = function() {
      return "SELECT * FROM " + this.name + "\n" + (this.whereIn()) + ";";
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

  matchCount = function(str, re) {
    return (str.match(re) || []).length;
  };

  decideSeparator = function(str) {
    var comma, tab;
    comma = matchCount(str, /,/g);
    tab = matchCount(str, /\t/g);
    if (comma > tab) {
      return ',';
    } else {
      return '\t';
    }
  };

  this.convert = function(mani, detail, csv) {
    var lines, sep, tableLines, tables;
    sep = decideSeparator(csv);
    lines = dropEmptyLine(csv.split('\n'));
    tables = (function() {
      var results;
      results = [];
      while (lines.length > 0) {
        tableLines = _.takeWhile(lines, nonEmpty);
        lines = _.dropWhile(lines, nonEmpty);
        lines = dropEmptyLine(lines);
        results.push(new Table(tableLines, sep));
      }
      return results;
    })();
    return tables.map(function(t) {
      return t.toSQL(mani, detail);
    }).filter(function(s) {
      return s != null;
    }).join('\n\n');
  };

}).call(this);
