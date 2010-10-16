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

    "should set the resource path to /name": (assert) ->
      assert.equal @bucket.resource.path, "/posts"
      assert.done()