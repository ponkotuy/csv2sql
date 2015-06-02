
Manipulations = ['INSERT', 'DELETE', 'SELECT']

details = (m) ->
  switch m
    when 'INSERT' then ['default', 'divided']
    else []

ManiSelector = React.createClass
  propTypes:
    onChange: React.PropTypes.func.isRequired

  getInitialState: ->
    now: ''
    detail: ''

  details: () ->
    details(@state.now)

  onClick: (m, d) ->
    () =>
      if @state.now != m
        d = if details(m).length > 0 then details(m)[0] else ''
      @setState {now: m, detail: d}
      @props.onChange(m, d)

  render: ->
    <div>
      <div className="col-sm-3">
        <div className="list-group top-margin">
          {
            Manipulations.map (x) =>
              <a className={'list-group-item ' + (if @state.now == x then 'active')} onClick={@onClick(x, @state.detail)}>{x}</a>
          }
        </div>
      </div>
      <div className="col-sm-3">
        <div className="list-group top-margin">
          {
            @details().map (x) =>
              <a href="#" className={'list-group-item ' + (if @state.detail == x then 'active')} onClick={@onClick(@state.now, x)}>{x}</a>
          }
        </div>
      </div>
    </div>

Changer = React.createClass
  getInitialState: ->
    csv: """
         ship
         type,class,name,weight
         軽巡洋艦,川内型,那珂,5195
         重巡洋艦,利根型,利根,11213
         """
    sql: ''
    now: ''
    detail: ''

  changeCSV: (e) ->
    @setState {csv: e.target.value}
    if @state.now != ''
      @setState {sql: convert(@state.now, e.target.value)}

  convert: (now, detail) ->
    @setState {sql: convert(now, detail, @state.csv), now: now, detail: detail}

  save: () ->
    saveFile("#{@state.now}.sql", @state.sql)

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
        <div className="col-sm-3">
          <div className="top-margin">
            <button type="button" id="save" className="btn brn-default" onClick={@save}>Save file</button>
          </div>
        </div>
      </div>
    </form>


saveFile = (name, text) ->
  blob = new Blob([text], {type: 'text/plain'})
  a = document.createElement('a')
  a.href = window.URL.createObjectURL(blob)
  a.target = '_blank'
  a.download = name
  a.click()


window.onload = ->
  React.render <Changer />, document.getElementById('changer')
