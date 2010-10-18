helper = require './helper'

module.exports =
  "The resource of an robj": testCase
    setUp: ->
      @bucket = new Bucket "posts"
      @robj = new Robject @bucket
      @robj.path = '/path'
      @resource = new Resource @robj

    "should have a client": (assert) ->
      assert.ok @resource.client instanceof Client
      assert.done()
    
    "should have the same path as the entity": (assert) ->
      assert.equal @resource.path, '/path'
      assert.done()

    "should drink beer if client emits beer": (assert) ->
      helper.stub @robj, 'drink'
      helper.stub @resource, 'drink', (beer) ->
        assert.equal "beer!", beer
      @resource.client.emit 'beer', "beer!"
      assert.expect 1
      assert.done()

    "should make robj drink beer if client emits beer": (assert) ->
      helper.stub @resource, 'drink'
      helper.stub @robj, 'drink', (beer) ->
        assert.equal "beer!", beer
      @resource.client.emit 'beer', "beer!"
      assert.expect 1
      assert.done()
    
    "should make robj barf an error with statusCode": (assert) ->
      helper.stub @robj, 'error'
      @robj.on 'barf', (error) ->
        assert.equal error.statusCode, 400
      err = new Error "400 Bad Request."
      err.statusCode = 400
      @resource.client.emit 'barf', err
      assert.expect 1
      assert.done()
    
    "should make robj barf an error with default message": (assert) ->
      helper.stub @robj, 'error'
      @robj.on 'barf', (error) ->
        assert.equal error.message, "400 Bad Request."
      err = new Error "400 Bad Request."
      err.statusCode = 400
      @resource.client.emit 'barf', err
      assert.expect 1
      assert.done()
    
    "should make robj barf an error with a customized message": (assert) ->
      helper.stub @robj, 'error', (error) -> "Invalid JSON"
      @robj.on 'barf', (error) ->
        assert.equal error.message, "400 Bad Request. Invalid JSON."
      err = new Error "400 Bad Request."
      err.statusCode = 400
      @resource.client.emit 'barf', err
      assert.expect 1
      assert.done()
    
    "should generate headers": (assert) ->
      assert.deepEqual @resource.headers(), {'content-type':"application/json"}
      assert.done()
    
    "should JSON.stringify data into rawData": (assert) ->
      @resource.data = {chug: "brew"}
      @resource.serialize()
      assert.equal @resource.rawData, "{\"chug\":\"brew\"}"
      assert.done()
    
    "should not JSON.stringify data into rawData if there is no data": (assert) ->
      @resource.rawData = "brewtownusa"
      @resource.data = undefined
      @resource.serialize()
      assert.equal @resource.rawData, "brewtownusa"
      assert.done()
    
    "should JSON.parse rawData into data": (assert) ->
      @resource.rawData = "{\"beers\":10}"
      @resource.deserialize()
      assert.deepEqual @resource.data, {beers: 10}
      assert.done()
    
    "should not JSON.parse rawData into data if there is no rawData": (assert) ->
      @resource.data = {beers: 10}
      @resource.rawData = undefined
      @resource.deserialize()
      assert.deepEqual @resource.data, {beers: 10}
      assert.done()
    
    "should serialize on store": (assert) ->
      helper.stub @resource, 'serialize', -> assert.ok true
      helper.stub @resource.client, 'put'
      @resource.store()
      assert.expect 1
      assert.done()
    
    "should call client post with path, headers, opts, and rawData": (assert) ->
      @resource.rawData = "rawData!"
      helper.stub @resource, 'serialize'
      helper.stub @resource, 'headers', -> {header: "value"}
      helper.stub @resource.client, 'post', (path, headers, opts, data) ->
        assert.equal path, '/path'
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, 'rawData!'
      @resource.store {option: "value"}, 'post'
      assert.expect 4
      assert.done()
    
    "should call client get with path, headers, and opts": (assert) ->
      helper.stub @resource, 'headers', -> {header: "value"}
      helper.stub @resource.client, 'get', (path, headers, opts, data) ->
        assert.equal path, '/path'
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, undefined
      @resource.get {option: "value"}
      assert.expect 4
      assert.done()
    
    "should assign buffer to rawData if buffer exists and is not blank": (assert) ->
      helper.stub @resource, 'deserialize'
      @resource.ingest 'beer!'
      assert.equal @resource.rawData, 'beer!'
      assert.done()
    
    "should deserialize if buffer exists and is not blank": (assert) ->
      helper.stub @resource, 'deserialize', ->
        assert.ok true
      @resource.ingest 'beer!'
      assert.expect 1
      assert.done()
    
    "should not assign buffer to rawData if buffer is undefined": (assert) ->
      helper.stub @resource, 'deserialize'
      @resource.rawData = 'beer!'
      @resource.ingest undefined
      assert.equal @resource.rawData, 'beer!'
      assert.done()
    
    "should not deserialize if buffer is undefined": (assert) ->
      helper.stub @resource, 'deserialize', ->
        assert.ok true
      @resource.ingest undefined
      assert.expect 0
      assert.done()
    
    "should not assign buffer to rawData if buffer is blank": (assert) ->
      helper.stub @resource, 'deserialize'
      @resource.rawData = 'beer!'
      @resource.ingest ''
      assert.equal @resource.rawData, 'beer!'
      assert.done()
    
    "should not deserialize if buffer is blank": (assert) ->
      helper.stub @resource, 'deserialize', ->
        assert.ok true
      @resource.ingest ''
      assert.expect 0
      assert.done()
    
    "should set contentType based on content-type header": (assert) ->
      beer = {headers: {location: "/riak/posts/321", 'content-type': "some/type"}}
      @resource.drink beer
      assert.equal @resource.contentType, 'some/type'
      assert.done()
    
    "should ingest the beer buffer": (assert) ->
      helper.stub @resource, 'ingest', (buffer) ->
        assert.equal buffer, 'beer!'
      beer = {buffer: 'beer!', headers: {location: "/riak/posts/321"}}
      @resource.drink beer
      assert.expect 1
      assert.done()