helper = require './helper'

module.exports =
  "An robj with a bucket and a key": testCase
    setUp: ->
      @bucket = new Bucket "posts"
      @robj = new Robject @bucket, '123'

    "should have a key": (assert) ->
      assert.equal @robj.key, '123'
      assert.done()

    "should set the resource path to the bucket path plus the key": (assert) ->
      assert.equal @robj.resource.path, "#{@bucket.path}/123"
      assert.done()

    "should get the resource on read if key is present": (assert) ->
      helper.stub @robj.resource, 'get', (opts) ->
        assert.deepEqual opts, {option: "value"}
      @robj.read({option: "value"})
      assert.expect 1
      assert.done()

    "should put resource with options": (assert) ->
      helper.stub @robj.resource, 'store', (opts, meth) ->
        assert.deepEqual opts, {option: "value"}
        assert.equal meth, 'put'
      @robj.store({option: "value"})

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

    "should set the resource path to the bucket path": (assert) ->
      assert.equal @robj.resource.path, @bucket.path
      assert.done()

    "should barf on read without key": (assert) ->
      @robj.on 'barf', (barf) ->
        assert.ok barf.message?
      @robj.read()
      assert.expect 1
      assert.done()

    "should post resource with options": (assert) ->
      helper.stub @robj.resource, 'store', (opts, meth) ->
        assert.deepEqual opts, {option: "value"}
        assert.equal meth, 'post'
      @robj.store({option: "value"})
      

    "should set key based on location header": (assert) ->
      beer = {headers: {location: "/riak/posts/321"}}
      @robj.drink beer
      assert.equal @robj.key, '321'
      assert.done()

    "should make resource drink beer when robj drinks beer": (assert) ->
      cheapBeer = {headers: {location: "/riak/posts"}}
      helper.stub @robj.resource, 'drink', (beer) ->
        assert.equal cheapBeer, beer
      @robj.drink cheapBeer
      assert.expect 1
      assert.done()

    "should emit beer on drink": (assert) ->
      beer = {headers: {location: "/riak/posts"}}
      @robj.on 'beer', ->
        assert.ok true
      @robj.drink beer
      assert.expect 1
      assert.done()
    
    "should make bucket emit beer with this on drink": (assert) ->
      beer = {headers: {location: "/riak/posts"}}
      @robj.bucket.on 'beer', (robj) =>
        assert.equal @robj, robj
      @robj.drink beer
      assert.expect 1
      assert.done()