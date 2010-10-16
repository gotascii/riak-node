helper = require './helper'

module.exports =
  "A bucket": testCase
    setUp: ->
      @bucket = new Bucket "posts"

    tearDown: ->
      helper.unstub()

    "should have a name": (assert) ->
      assert.equals @bucket.name, "posts"
      assert.done()

    "should have a resource": (assert) ->
      assert.ok @bucket.resource instanceof Resource
      assert.done()

    "should set the path to /name": (assert) ->
      assert.equal @bucket.path, "/posts"
      assert.done()

    "should delegate store to resource": (assert) ->
      helper.stub @bucket.resource, 'store', (opts) ->
        assert.deepEqual opts, {option:'value'}
      @bucket.store {option:'value'}
      assert.expect 1
      assert.done()

    "should delegate read to resource get": (assert) ->
      helper.stub @bucket.resource, 'get', (opts) ->
        assert.deepEqual opts, {option:'value'}
      @bucket.read {option:'value'}
      assert.expect 1
      assert.done()