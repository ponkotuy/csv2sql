(function() {
  this.createInsert = function(detail, table) {
    var first, inserts;
    switch (detail) {
      case 'divided':
        first = `INSERT INTO ${table.name} (${table.columns.join(', ')}) VALUES`;
        inserts = table.records.map(function(line) {
          return `${first} (${line.join(', ')});`;
        });
        return inserts.join('\n');
      default:
        return `INSERT INTO ${table.name} (${table.columns.join(', ')}) VALUES\n  ${table.linesWithComma().join(',\n  ')};`;
    }
  };

}).call(this);
