
Manipulations = ['INSERT', 'DELETE', 'SELECT']

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
    csv: """
         ship
         type,class,name,weight
         軽巡洋艦,川内型,那珂,5195
         重巡洋艦,利根型,利根,11213
         """
    sql: ''
    now: ''

  changeCSV: (e) ->
    @setState {csv: e.target.value}
    if @state.now != ''
      @setState {sql: convert(@state.now, e.target.value)}

  convert: (now) ->
    @setState {sql: convert(now, @state.csv), now: now}

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
        <div className="col-sm-offset-3 col-sm-3">
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
