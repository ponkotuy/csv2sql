
@createInsert = (detail, table) ->
  switch detail
    when 'divided'
      first = "INSERT INTO #{table.name} (#{table.columns.join(', ')}) VALUES"
      inserts = table.records.map (line) ->
         "#{first} (#{line.join(', ')});"
      inserts.join('\n')
    else
      """
      INSERT INTO #{table.name} (#{table.columns.join(', ')}) VALUES
        #{table.linesWithComma().join(',\n  ')};
      """
