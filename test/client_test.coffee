Client = require('../lib/client')
helper = require './helper'
testCase = require('nodeunit').testCase

module.exports = testCase
  setUp: -> @client = new Client

  tearDown: ->
    helper.unstub()

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
    helper.stub @client, 'exec', (method, path, headers, data, opts) ->
      assert.equal method, 'PUT'
      assert.equal path, "/path"
      assert.deepEqual headers, {header: "value"}
      assert.equal data, "raw data"
      assert.deepEqual opts, {option: "value"}
      assert.done()
    @client.put("/path", {header: "value"}, "raw data", {option: "value"})

  "test should call exec with method GET and pass along args": (assert) ->
    helper.stub @client, 'exec', (method, path, headers, data, opts) ->
      assert.equal method, 'GET'
      assert.equal path, "/path"
      assert.deepEqual headers, {header: "value"}
      assert.equal data, undefined
      assert.deepEqual opts, {option: "value"}
      assert.done()
    @client.get("/path", {header: "value"}, {option: "value"})

  "test should add querystring to a path": (assert) ->
    path = @client.querify("/path", {option: "value"})
    assert.equal path, "/path?option=value"