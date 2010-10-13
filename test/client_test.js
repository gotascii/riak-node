(function() {
  var Client, testCase;
  Client = require('../lib/client');
  testCase = require('nodeunit').testCase;
  module.exports = testCase({
    setUp: function() {
      return (this.client = new Client());
    },
    "test should have /riak prefix": function(assert) {
      assert.equal(this.client.prefix, "/riak");
      return assert.done();
    },
    "test should have utf8 encoding": function(assert) {
      assert.equal(this.client.encoding, "utf8");
      return assert.done();
    },
    "test should have http.client with port 8098": function(assert) {
      assert.equal(this.client.client.port, 8098);
      return assert.done();
    },
    "test should emit barf on client error": function(assert) {
      this.client.on('barf', function(exception) {
        assert.equal(exception.message, "error!");
        return assert.done();
      });
      return this.client.client.emit('error', {
        message: 'error!'
      });
    },
    "test should call exec with method PUT and pass along args": function(assert) {
      var _exec;
      _exec = this.client.exec;
      this.client.exec = function(method, path, headers, data, opts) {
        assert.equal(method, 'PUT');
        assert.equal(path, "/path");
        assert.deepEqual(headers, {
          header: "value"
        });
        assert.equal(data, "raw data");
        assert.deepEqual(opts, {
          option: "value"
        });
        assert.done();
        return (this.client.exec = _exec);
      };
      return this.client.put("/path", {
        header: "value"
      }, "raw data", {
        option: "value"
      });
    },
    "test should call exec with method GET and pass along args": function(assert) {
      var _exec;
      _exec = this.client.exec;
      this.client.exec = function(method, path, headers, data, opts) {
        assert.equal(method, 'GET');
        assert.equal(path, "/path");
        assert.deepEqual(headers, {
          header: "value"
        });
        assert.equal(data, undefined);
        assert.deepEqual(opts, {
          option: "value"
        });
        assert.done();
        return (this.client.exec = _exec);
      };
      return this.client.get("/path", {
        header: "value"
      }, {
        option: "value"
      });
    },
    "test should add querystring to a path": function(assert) {
      var path;
      path = this.client.querify("/path", {
        option: "value"
      });
      return assert.equal(path, "/path?option=value");
    }
  });
})();
