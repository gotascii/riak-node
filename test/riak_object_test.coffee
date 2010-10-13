sys = require 'sys'
RiakObject = require('../lib/riak_object')
Bucket = require('../lib/bucket')
testCase = require('nodeunit').testCase

# robj = new RiakObject(posts)
# robj.data = {terd: "licks"}
# robj.on 'beer', ->
#   sys.puts("robj: #{sys.inspect(robj)}")
#   robj3 = new RiakObject(posts, robj.key)
#   robj3.on 'beer', -> sys.puts("robj3: #{sys.inspect(robj3)}")
#   robj3.read()
# robj.store()

module.exports =
  testWithBucket: testCase
    setUp: ->
      @posts = new Bucket "posts"
      @robj = new RiakObject @posts

    testHasBucket: (assert) ->
      assert.equal @posts, @robj.bucket
      assert.done()

    testHasNoKey: (assert) ->
      assert.equal undefined, @robj.key
      assert.done()

    testHasPath: (assert) ->
      assert.equal "/posts", @robj.path
      assert.done()

    testDefaultContentTypeJSON: (assert) ->
      assert.equal "application/json", @robj.contentType
      assert.done()

    testDefaultContentTypeJSON: (assert) ->
      assert.equal "application/json", @robj.contentType
      assert.done()

    testGeneratesHeaders: (assert) ->
      assert.deepEqual {'content-type':"application/json"}, @robj.headers()
      assert.done()

    testStoreEmitsBeerOnSelf: (assert) ->
      test = this
      @robj.on 'beer', ->
        assert.equals test.robj, this
        assert.done()
      @robj.store()