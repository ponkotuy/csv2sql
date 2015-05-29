
Manipulations = ['SELECT', 'INSERT', 'DELETE', 'UPSERT']

ManiSelector = React.createClass
  getInitialState: ->
    now: Manipulations[0]

  onClick: (m) ->
    () =>
      @setState {now: m}

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
  render: ->
    <form>
      <div className="row">
        <div className="col-sm-6">
          <h3><label htmlFor="csv">CSV</label></h3>
          <textarea id="csv" className="form-control" rows="10"></textarea>
        </div>
        <div className="col-sm-6">
          <h3><label htmlFor="sql">SQL</label></h3>
          <textarea id="sql" className="form-control" rows="10"></textarea>
        </div>
      </div>

      <div className="row">
        <ManiSelector />
        <div className="col-sm-offset-3 col-sm-3">
          <div className="top-margin">
            <button type="button" id="save" className="btn brn-default">Save file</button>
          </div>
        </div>
      </div>
    </form>

window.onload = ->
  React.render <Changer />, document.getElementById('changer')
