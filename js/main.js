(function() {
  var Changer, ManiSelector, Manipulations, details, saveFile;

  Manipulations = ['INSERT', 'DELETE', 'SELECT'];

  details = function(m) {
    switch (m) {
      case 'INSERT':
        return ['default', 'divided'];
      default:
        return [];
    }
  };

  ManiSelector = React.createClass({displayName: "ManiSelector",
    propTypes: {
      onChange: React.PropTypes.func.isRequired
    },
    getInitialState: function() {
      return {
        now: '',
        detail: ''
      };
    },
    details: function() {
      return details(this.state.now);
    },
    onClick: function(m, d) {
      return (function(_this) {
        return function() {
          if (_this.state.now !== m) {
            d = details(m).length > 0 ? details(m)[0] : '';
          }
          _this.setState({
            now: m,
            detail: d
          });
          return _this.props.onChange(m, d);
        };
      })(this);
    },
    render: function() {
      return React.createElement("div", null, React.createElement("div", {
        "className": "col-sm-3"
      }, React.createElement("div", {
        "className": "list-group top-margin"
      }, Manipulations.map((function(_this) {
        return function(x) {
          return React.createElement("a", {
            "className": 'list-group-item ' + (_this.state.now === x ? 'active' : void 0),
            "onClick": _this.onClick(x, _this.state.detail)
          }, x);
        };
      })(this)))), React.createElement("div", {
        "className": "col-sm-3"
      }, React.createElement("div", {
        "className": "list-group top-margin"
      }, this.details().map((function(_this) {
        return function(x) {
          return React.createElement("a", {
            "href": "#",
            "className": 'list-group-item ' + (_this.state.detail === x ? 'active' : void 0),
            "onClick": _this.onClick(_this.state.now, x)
          }, x);
        };
      })(this)))));
    }
  });

  Changer = React.createClass({displayName: "Changer",
    getInitialState: function() {
      return {
        csv: "ship\ntype,class,name,weight\n軽巡洋艦,川内型,那珂,5195\n重巡洋艦,利根型,利根,11213",
        sql: '',
        now: '',
        detail: ''
      };
    },
    changeCSV: function(e) {
      this.setState({
        csv: e.target.value
      });
      if (this.state.now !== '') {
        return this.setState({
          sql: convert(this.state.now, this.state.detail, e.target.value)
        });
      }
    },
    convert: function(now, detail) {
      return this.setState({
        sql: convert(now, detail, this.state.csv),
        now: now,
        detail: detail
      });
    },
    save: function() {
      return saveFile(this.state.now + ".sql", this.state.sql);
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
        "className": "col-sm-3"
      }, React.createElement("div", {
        "className": "top-margin"
      }, React.createElement("button", {
        "type": "button",
        "id": "save",
        "className": "btn brn-default",
        "onClick": this.save
      }, "Save file")))));
    }
  });

  saveFile = function(name, text) {
    var a, blob;
    console.log(name, text);
    blob = new Blob([text], {
      type: 'text/plain'
    });
    a = document.createElement('a');
    a.href = window.URL.createObjectURL(blob);
    a.download = name;
    document.body.appendChild(a);
    a.click();
    return a.parentNode.removeChild(a);
  };

  window.onload = function() {
    return React.render(React.createElement(Changer, null), document.getElementById('changer'));
  };

}).call(this);
