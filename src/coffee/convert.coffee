
convertCell = (cell) ->
  cell = cell.trim()
  if cell.length > 0 and (cell[0] not in ['"', "'"]) and isNaN(cell)
    "'" + cell + "'"
  else
    cell

class Table
  constructor: (@lines) ->
    @name = @lines[0]
    @columns = @lines[1].split(',')
    @records = @lines.slice(2).map (l) ->
       l.split(',').map(convertCell)

  # nullable
  toSQL: (mani) ->
    switch mani
      when 'INSERT' then @createInsert()
      when 'DELETE' then @createDelete()
      when 'SELECT' then @createSelect()
      else null

  linesWithComma: () -> @records.map (line) -> "(#{line.join(', ')})"

  whereIn: () ->
    if @columns.length == 1
      "  WHERE #{@columns[0]} IN (#{@records.concat().join(', ')})"
    else
      "  WHERE (#{@columns.join(', ')}) IN (\n    #{@linesWithComma().join(',\n    ')})"

  createInsert: ->
    """
    INSERT INTO #{@name} (#{@columns.join(', ')}) VALUES
      #{@linesWithComma().join(',\n  ')};
    """

  createDelete: ->
    """
    DELETE FROM #{@name}
    #{@whereIn()};
    """

  createSelect: ->
    """
    SELECT * FROM #{@name}
    #{@whereIn()};
    """

isEmpty = (str) -> str == ''
nonEmpty = (str) -> str != ''
dropEmptyLine = (xs) -> _.dropWhile(xs, isEmpty)

@convert = (mani, csv) ->
  lines = dropEmptyLine(csv.split('\n'))
  tables = while lines.length > 0
    tableLines = _.takeWhile(lines, nonEmpty)
    lines = _.dropWhile(lines, nonEmpty)
    lines = dropEmptyLine(lines)
    new Table(tableLines)
  tables.map (t) -> t.toSQL(mani)
    .filter (s) -> s?
    .join('\n\n')
