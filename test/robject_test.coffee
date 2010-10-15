helper = require './helper'

module.exports =
  "An robj with a bucket": testCase
    setUp: ->
      @bucket = new Bucket "posts"
      @robj = new Robject @bucket

    tearDown: ->
      helper.unstub()

    "should have a bucket": (assert) ->
      assert.equal @robj.bucket, @bucket
      assert.done()

    "should not have a key": (assert) ->
      assert.equal @robj.key, undefined
      assert.done()
    
    "should have a path that matches the bucket path": (assert) ->
      assert.equal @robj.path, @bucket.path
      assert.done()
    
    "should have a contentType of application/json": (assert) ->
      assert.equal @robj.contentType, "application/json"
      assert.done()

    "should have a client": (assert) ->
      assert.ok @robj.client instanceof Client
      assert.done()

    "should drink beer if client emits beer": (assert) ->
      helper.stub @robj, 'drink', (beer) => assert.equal "beer!", beer
      @robj.client.emit 'beer', "beer!"
      assert.expect 1
      assert.done()

    "should emit barf if client emits barf": (assert) ->
      @robj.on 'barf', (barf) ->
        assert.equal barf, "barf!"
      @robj.client.emit 'barf', "barf!"
      assert.expect 1
      assert.done()

    "should generate headers": (assert) ->
      assert.deepEqual @robj.headers(), {'content-type':"application/json"}
      assert.done()

    "should JSON.stringify data into rawData": (assert) ->
      @robj.data = {chug: "brew"}
      @robj.serialize()
      assert.equal @robj.rawData, "{\"chug\":\"brew\"}"
      assert.done()

    "should not JSON.stringify data into rawData if there is no data": (assert) ->
      @robj.rawData = "brewtownusa"
      @robj.data = undefined
      @robj.serialize()
      assert.equal @robj.rawData, "brewtownusa"
      assert.done()

    "should JSON.parse rawData into data": (assert) ->
      @robj.rawData = "{\"beers\":10}"
      @robj.deserialize()
      assert.deepEqual @robj.data, {beers: 10}
      assert.done()

    "should not JSON.parse rawData into data if there is no rawData": (assert) ->
      @robj.data = {beers: 10}
      @robj.rawData = undefined
      @robj.deserialize()
      assert.deepEqual @robj.data, {beers: 10}
      assert.done()

    "should serialize on store": (assert) ->
      helper.stub @robj, 'serialize', -> assert.ok true
      helper.stub @robj.client, 'post'
      @robj.store()
      assert.expect 1
      assert.done()

    "should call client post with path, headers, opts, and rawData": (assert) ->
      @robj.rawData = "rawData!"
      @robj.path = '/path'
      helper.stub @robj, 'serialize'
      helper.stub @robj, 'headers', -> {header: "value"}
      helper.stub @robj.client, 'post', (path, headers, opts, data) ->
        assert.equal path, '/path'
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, 'rawData!'
      @robj.store {option: "value"}
      assert.expect 4
      assert.done()

    "should barf on read without key": (assert) ->
      @robj.on 'barf', (barf) ->
        assert.ok barf.message?
      @robj.read()
      assert.expect 1
      assert.done()

    "should call client get with path, headers, and opts": (assert) ->
      @robj.key = '1'
      @robj.path = '/path'
      helper.stub @robj, 'headers', -> {header: "value"}
      helper.stub @robj.client, 'get', (path, headers, opts, data) ->
        assert.equal path, '/path'
        assert.deepEqual headers, {header: "value"}
        assert.deepEqual opts, {option: "value"}
        assert.equal data, undefined
      @robj.read {option: "value"}
      assert.expect 4
      assert.done()

    "should assign buffer to rawData if buffer exists and is not blank": (assert) ->
      helper.stub @robj, 'deserialize'
      @robj.ingest 'beer!'
      assert.equal @robj.rawData, 'beer!'
      assert.done()

    "should deserialize if buffer exists and is not blank": (assert) ->
      helper.stub @robj, 'deserialize', ->
        assert.ok true
      @robj.ingest 'beer!'
      assert.expect 1
      assert.done()

    "should not assign buffer to rawData if buffer is undefined": (assert) ->
      helper.stub @robj, 'deserialize'
      @robj.rawData = 'beer!'
      @robj.ingest undefined
      assert.equal @robj.rawData, 'beer!'
      assert.done()

    "should not deserialize if buffer is undefined": (assert) ->
      helper.stub @robj, 'deserialize', ->
        assert.ok true
      @robj.ingest undefined
      assert.expect 0
      assert.done()

    "should not assign buffer to rawData if buffer is blank": (assert) ->
      helper.stub @robj, 'deserialize'
      @robj.rawData = 'beer!'
      @robj.ingest ''
      assert.equal @robj.rawData, 'beer!'
      assert.done()

    "should not deserialize if buffer is blank": (assert) ->
      helper.stub @robj, 'deserialize', ->
        assert.ok true
      @robj.ingest ''
      assert.expect 0
      assert.done()

    "should set key based on location header": (assert) ->
      beer = {headers: {location: "/riak/posts/321"}}
      @robj.drink beer
      assert.equal @robj.key, '321'
      assert.done()

    "should not set key if a location is not present": (assert) ->
      beer = {headers: {header: "value"}}
      @robj.key = '123'
      @robj.drink beer
      assert.equal @robj.key, '123'
      assert.done()

    "should set contentType based on content-type header": (assert) ->
      beer = {headers: {'content-type': "some/type"}}
      @robj.drink beer
      assert.equal @robj.contentType, 'some/type'
      assert.done()

    "should ingest the beer buffer": (assert) ->
      helper.stub @robj, 'ingest', (buffer) ->
        assert.equal buffer, 'beer!'
      beer = {buffer: 'beer!', headers: {}}
      @robj.drink beer
      assert.expect 1
      assert.done()

    "should emit beer on drink": (assert) ->
      beer = {headers: {}}
      @robj.on 'beer', ->
        assert.ok true
      @robj.drink beer
      assert.expect 1
      assert.done()

    "should make bucket emit beer with self on drink": (assert) ->
      beer = {headers: {}}
      @robj.bucket.on 'beer', (robj) =>
        assert.equal @robj, robj
      @robj.drink beer
      assert.expect 1
      assert.done()