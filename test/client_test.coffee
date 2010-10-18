helper = require './helper'

module.exports =
  "A client": testCase
    setUp: -> @client = new Client

    tearDown: ->
      helper.unstub()

    "should have /riak prefix": (assert) ->
      assert.equal @client.prefix, "/riak"
      assert.done()
  
    "should have utf8 encoding": (assert) ->
      assert.equal @client.encoding, "utf8"
      assert.done()

    "should have http.client with port 8098": (assert) ->
      assert.equal @client.client.port, 8098
      assert.done()

    "should make emitter emit barf on client error": (assert) ->
      @client.on 'barf', (exception) ->
        assert.equal exception.message, "error!"
      @client.client.emit 'error',
        message: 'error!'
      assert.expect 1
      assert.done()

    "should call exec with method PUT and pass along args": (assert) ->
      helper.stub @client, 'exec', (method, path, headers, opts, data) ->
        assert.equal method, 'PUT'
        assert.equal path, "/path"
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, "raw data"
      @client.put("/path", {header: "value"}, {option: "value"}, "raw data")
      assert.expect 5
      assert.done()

    "should call exec with method GET and pass along args": (assert) ->
      helper.stub @client, 'exec', (method, path, headers, opts, data) ->
        assert.equal method, 'GET'
        assert.equal path, "/path"
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, undefined
      @client.get("/path", {header: "value"}, {option: "value"})
      assert.expect 5
      assert.done()

    "should add prefix and querystring to path": (assert) ->
      path = @client.querify("/path", {option: "value"})
      assert.equal path, "/riak/path?option=value"
      assert.done()

    "should be undefined if statusCode is less than 400": (assert) ->
      err = @client.error({statusCode: 399})
      assert.equal err, undefined
      assert.done()

    "should return error if statusCode is equal to 400": (assert) ->
      err = @client.error({statusCode: 400})
      assert.ok err instanceof Error
      assert.done()

    "should return error if statusCode is greater than 400": (assert) ->
      err = @client.error({statusCode: 401})
      assert.ok err instanceof Error
      assert.done()

    "should have message that contains the error code": (assert) ->
      err = @client.error({statusCode: 401})
      assert.equal err.message, "401"
      assert.done()

    "should have message that contains the error code and description": (assert) ->
      err = @client.error({statusCode: 400})
      assert.equal err.message, "400 Bad Request."
      assert.done()

    "should have the statusCode in the error": (assert) ->
      err = @client.error({statusCode: 400})
      assert.equal err.statusCode, 400
      assert.done()