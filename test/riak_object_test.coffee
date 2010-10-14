sys = require 'sys'
RiakObject = require '../lib/riak_object'
Bucket = require '../lib/bucket'
Client = require '../lib/client'
helper = require './helper'
testCase = require('nodeunit').testCase

module.exports =
  "An robj with a bucket": testCase
    setUp: ->
      @bucket = new Bucket "posts"
      @robj = new RiakObject @bucket

    tearDown: ->
      helper.unstub()

    "should have a bucket": (assert) ->
      assert.equal @bucket, @robj.bucket
      assert.done()

    "should not have a key": (assert) ->
      assert.equal undefined, @robj.key
      assert.done()
    
    "should have a path that matches the bucket path": (assert) ->
      assert.equal @bucket.path, @robj.path
      assert.done()
    
    "should have a contentType of application/json": (assert) ->
      assert.equal "application/json", @robj.contentType
      assert.done()

    "should have a client": (assert) ->
      assert.ok @robj.client instanceof Client
      assert.done()

    "should drink beer if client emits beer": (assert) ->
      helper.stub @robj, 'drink', (beer) => assert.equal "beer!", beer
      @robj.client.emit 'beer', "beer!"
      assert.expect(1)
      assert.done()

    "should emit barf if client emits barf": (assert) ->
      @robj.on 'barf', (barf) ->
        assert.equal "barf!", barf
      @robj.client.emit 'barf', "barf!"
      assert.expect(1)
      assert.done()

    "should generate headers": (assert) ->
      assert.deepEqual {'content-type':"application/json"}, @robj.headers()
      assert.done()

    "should JSON.stringify data into rawData": (assert) ->
      @robj.data = {chug: "brew"}
      @robj.serialize()
      assert.equal "{\"chug\":\"brew\"}", @robj.rawData
      assert.done()

    "should not JSON.stringify data into rawData if there is no data": (assert) ->
      @robj.rawData = "brewtownusa"
      @robj.data = undefined
      @robj.serialize()
      assert.equal "brewtownusa", @robj.rawData
      assert.done()

    "should JSON.parse rawData into data": (assert) ->
      @robj.rawData = "{\"beers\":10}"
      @robj.deserialize()
      assert.deepEqual {beers: 10}, @robj.data
      assert.done()

    "should not JSON.parse rawData into data if there is no rawData": (assert) ->
      @robj.data = {beers: 10}
      @robj.rawData = undefined
      @robj.deserialize()
      assert.deepEqual {beers: 10}, @robj.data
      assert.done()

    "should serialize on store": (assert) ->
      helper.stub @robj, 'serialize', -> assert.ok true
      helper.stub @robj.client, 'post'
      @robj.store()
      assert.expect(1)
      assert.done()

    "should call client post with path, headers, opts, and rawData": (assert) ->
      @robj.rawData = "rawData!"
      @robj.path = '/path'
      helper.stub @robj, 'serialize'
      helper.stub @robj, 'headers', -> {header: "value"}
      helper.stub @robj.client, 'post', (path, headers, opts, data) ->
        assert.equal '/path', path
        assert.deepEqual {header: "value"}, headers
        assert.deepEqual {option: "value"}, opts
        assert.equal 'rawData!', data
      @robj.store({option: "value"})
      assert.expect(4)
      assert.done()