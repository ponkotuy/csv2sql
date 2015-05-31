
Manipulations = ['INSERT', 'DELETE', 'UPSERT']

ManiSelector = React.createClass
  propTypes:
    onChange: React.PropTypes.func.isRequired

  getInitialState: ->
    now: ''

  onClick: (m) ->
    () =>
      @setState {now: m}
      @props.onChange(m)

  render: ->
    <div className="col-sm-3">
      <div className="list-group top-margin">
        {
          Manipulations.map (x) =>
            <a href="#" className={'list-group-item ' + (if @state.now == x then 'active')} onClick={@onClick(x)}>{x}</a>
        }
      </div>
    </div>

Changer = React.createClass
  getInitialState: ->
    csv: ''
    sql: ''
    now: ''

  changeCSV: (e) ->
    @setState {csv: e.target.value}
    if @state.now != ''
      @setState {sql: convert(@state.now, e.target.value)}

  convert: (now) ->
    @setState {sql: convert(now, @state.csv), now: now}

  render: ->
    <form>
      <div className="row">
        <div className="col-sm-6">
          <h3><label htmlFor="csv">CSV</label></h3>
          <textarea id="csv" className="form-control" rows="10" value={@state.csv} onChange={@changeCSV}></textarea>
        </div>
        <div className="col-sm-6">
          <h3><label htmlFor="sql">SQL</label></h3>
          <textarea id="sql" className="form-control" rows="10" value={@state.sql} readonly="readonly"></textarea>
        </div>
      </div>

      <div className="row">
        <ManiSelector onChange=@convert ref="mani" />
        <div className="col-sm-offset-3 col-sm-3">
          <div className="top-margin">
            <button type="button" id="save" className="btn brn-default">Save file</button>
          </div>
        </div>
      </div>
    </form>


class Table
  constructor: (@lines) ->
    @name = @lines[0]
    @columns = @lines[1].split(',')
    @records = @lines.slice(2).map (l) -> l.split(',')

  # nullable
  toSQL: (mani) ->
    switch mani
      when 'INSERT' then console.log(@createInsert()); @createInsert()
      when 'DELETE' then @createDelete()
      when 'UPSERT' then @createUpsert()
      else null

  createInsert: ->
    lines = @records.map (line) -> "(#{line.join(', ')})"
    """
    INSERT INTO #{@name} (#{@columns.join(', ')}) VALUES
      #{lines.join(',\n  ')};
    """

isEmpty = (str) -> str == ''
nonEmpty = (str) -> str != ''
dropEmptyLine = (xs) -> _.dropWhile(xs, isEmpty)
convert = (mani, csv) ->
  lines = dropEmptyLine(csv.split('\n'))
  tables = while lines.length > 0
    tableLines = _.takeWhile(lines, nonEmpty)
    lines = _.dropWhile(lines, nonEmpty)
    lines = dropEmptyLine(lines)
    new Table(tableLines)
  (tables.map (t) -> console.log(t); t.toSQL(mani)).join('\n\n')

window.onload = ->
  React.render <Changer />, document.getElementById('changer')
