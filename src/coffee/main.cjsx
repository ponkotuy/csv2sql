
Changer = React.createClass
  render: ->
    <form>
      <div className="col-sm-6">
        <h3><label for="csv">CSV</label></h3>
        <textarea id="csv" className="form-control" rows="10"></textarea>
      </div>
      <div className="col-sm-6">
        <h3><label for="sql">SQL</label></h3>
        <textarea id="sql" className="form-control" rows="10"></textarea>
      </div>
      <div className="col-sm-3">
        <div className="list-group top-margin">
          <a href="#" className="list-group-item active">SELECT</a>
          <a href="#" className="list-group-item">INSERT</a>
          <a href="#" className="list-group-item">DELETE</a>
          <a href="#" className="list-group-item">UPSERT</a>
        </div>
      </div>
      <div className="col-sm-offset-3 col-sm-3">
        <div className="top-margin">
          <button type="button" id="save" className="btn brn-default">Save file</button>
        </div>
      </div>
    </form>

window.onload = ->
  React.render <Changer />, document.getElementById('changer')
