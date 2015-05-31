(function() {
  var Changer, ManiSelector, Manipulations;

  Manipulations = ['INSERT', 'DELETE', 'SELECT'];

  ManiSelector = React.createClass({
    propTypes: {
      onChange: React.PropTypes.func.isRequired
    },
    getInitialState: function() {
      return {
        now: ''
      };
    },
    onClick: function(m) {
      return (function(_this) {
        return function() {
          _this.setState({
            now: m
          });
          return _this.props.onChange(m);
        };
      })(this);
    },
    render: function() {
      return React.createElement("div", {
        "className": "col-sm-3"
      }, React.createElement("div", {
        "className": "list-group top-margin"
      }, Manipulations.map((function(_this) {
        return function(x) {
          return React.createElement("a", {
            "href": "#",
            "className": 'list-group-item ' + (_this.state.now === x ? 'active' : void 0),
            "onClick": _this.onClick(x)
          }, x);
        };
      })(this))));
    }
  });

  Changer = React.createClass({
    getInitialState: function() {
      return {
        csv: "ship\ntype,class,name,weight\n軽巡洋艦,川内型,那珂,5195\n重巡洋艦,利根型,利根,11213",
        sql: '',
        now: ''
      };
    },
    changeCSV: function(e) {
      this.setState({
        csv: e.target.value
      });
      if (this.state.now !== '') {
        return this.setState({
          sql: convert(this.state.now, e.target.value)
        });
      }
    },
    convert: function(now) {
      return this.setState({
        sql: convert(now, this.state.csv),
        now: now
      });
    },
    render: function() {
      return React.createElement("form", null, React.createElement("div", {
        "className": "row"
      }, React.createElement("div", {
        "className": "col-sm-6"
      }, React.createElement("h3", null, React.createElement("label", {
        "htmlFor": "csv"
      }, "CSV")), React.createElement("textarea", {
        "id": "csv",
        "className": "form-control",
        "rows": "10",
        "value": this.state.csv,
        "onChange": this.changeCSV
      })), React.createElement("div", {
        "className": "col-sm-6"
      }, React.createElement("h3", null, React.createElement("label", {
        "htmlFor": "sql"
      }, "SQL")), React.createElement("textarea", {
        "id": "sql",
        "className": "form-control",
        "rows": "10",
        "value": this.state.sql,
        "readonly": "readonly"
      }))), React.createElement("div", {
        "className": "row"
      }, React.createElement(ManiSelector, {
        "onChange": this.convert,
        "ref": "mani"
      }), React.createElement("div", {
        "className": "col-sm-offset-3 col-sm-3"
      }, React.createElement("div", {
        "className": "top-margin"
      }))));
    }
  });

  window.onload = function() {
    return React.render(React.createElement(Changer, null), document.getElementById('changer'));
  };

}).call(this);
