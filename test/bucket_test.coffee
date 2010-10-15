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

    "should have a path": (assert) ->
      assert.equals @bucket.path, "/posts"
      assert.done()

    "should have a client": (assert) ->
      assert.ok @bucket.client instanceof Client
      assert.done()

    "should drink beer if client emits beer": (assert) ->
      helper.stub @bucket, 'drink', (beer) => assert.equal "beer!", beer
      @bucket.client.emit 'beer', "beer!"
      assert.expect 1
      assert.done()

    # "should emit barf if client emits barf": (assert) ->
    #   @robj.on 'barf', (barf) ->
    #     assert.equal barf, "barf!"
    #   @robj.client.emit 'barf', "barf!"
    #   assert.expect 1
    #   assert.done()