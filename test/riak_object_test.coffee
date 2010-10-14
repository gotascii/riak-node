sys = require 'sys'
RiakObject = require('../lib/riak_object')
Bucket = require('../lib/bucket')
Client = require('../lib/client')
testCase = require('nodeunit').testCase

module.exports =
  "test An robj with a bucket": testCase
    setUp: ->
      @bucket = new Bucket "posts"
      @robj = new RiakObject @bucket

    "test should have a bucket": (assert) ->
      assert.equal @bucket, @robj.bucket
      assert.done()

    "test should not have a key": (assert) ->
      assert.equal undefined, @robj.key
      assert.done()
    
    "test should have a path that matches the bucket path": (assert) ->
      assert.equal @bucket.path, @robj.path
      assert.done()
    
    "test should have a contentType of application/json": (assert) ->
      assert.equal "application/json", @robj.contentType
      assert.done()

    "test should have a client": (assert) ->
      assert.ok @robj.client instanceof Client
      assert.done()

    "test should drink beer if client emits beer": (assert) ->
      _drink = @robj.drink
      @robj.drink = (beer) =>
        assert.equal "beer!", beer
        assert.done()
        @robj.drink = _drink
      @robj.client.emit 'beer', "beer!"

    "test should emit barf if client emits barf": (assert) ->
      @robj.on 'barf', (barf) ->
        assert.equal "barf!", barf
        assert.done()
      @robj.client.emit 'barf', "barf!"

    "test should generate headers": (assert) ->
      assert.deepEqual {'content-type':"application/json"}, @robj.headers()
      assert.done()