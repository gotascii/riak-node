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

module.exports = testCase
  setUp: ->
    @posts = new Bucket "posts"
    @robj = new RiakObject @posts

  testLoadEmitsBeerOnBucket: (assert) ->
    test = this
    @posts.on 'beer', (robj) ->
      assert.equals test.robj, robj
      assert.done()
    @robj.store()

  testLoadEmitsBeerOnSelf: (assert) ->
    test = this
    @robj.on 'beer', ->
      assert.equals test.robj, this
      assert.done()
    @robj.store()