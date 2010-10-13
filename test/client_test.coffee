Client = require('../lib/client')
testCase = require('nodeunit').testCase

module.exports = testCase
  setUp: -> @client = new Client

  "test should have /riak prefix": (assert) ->
    assert.equal @client.prefix, "/riak"
    assert.done()
  
  "test should have utf8 encoding": (assert) ->
    assert.equal @client.encoding, "utf8"
    assert.done()

  "test should have http.client with port 8098": (assert) ->
    assert.equal @client.client.port, 8098
    assert.done()

  "test should emit barf on client error": (assert) ->
    @client.on 'barf', (exception) ->
      assert.equal exception.message, "error!"
      assert.done()
    @client.client.emit 'error',
      message: 'error!'

  "test should call exec with method PUT and pass along args": (assert) ->
    _exec = @client.exec
    @client.exec = (method, path, headers, data, opts) ->
      assert.equal method, 'PUT'
      assert.equal path, "/path"
      assert.deepEqual headers, {header: "value"}
      assert.equal data, "raw data"
      assert.deepEqual opts, {option: "value"}
      assert.done()
      @client.exec = _exec
    @client.put("/path", {header: "value"}, "raw data", {option: "value"})

  "test should call exec with method GET and pass along args": (assert) ->
    _exec = @client.exec
    @client.exec = (method, path, headers, data, opts) ->
      assert.equal method, 'GET'
      assert.equal path, "/path"
      assert.deepEqual headers, {header: "value"}
      assert.equal data, undefined
      assert.deepEqual opts, {option: "value"}
      assert.done()
      @client.exec = _exec
    @client.get("/path", {header: "value"}, {option: "value"})

  "test should add querystring to a path": (assert) ->
    path = @client.querify("/path", {option: "value"})
    assert.equal path, "/path?option=value"

  # querify: (path, opts) ->
  #   path = "#{prefix}#{path}"
  #   path += "?#{querystring.stringify(opts)}" if opts?
  #   path
