Bucket = require('../lib/bucket')
testCase = require('nodeunit').testCase

module.exports = testCase
  setUp: -> @posts = new Bucket "posts"

  testBucketName: (assert) ->
    assert.equals @posts.name, "posts"
    assert.done()

  testBucketPath: (assert) ->
    assert.equals @posts.path, "/posts"
    assert.done()

# Bucket = require('../lib/bucket')
# posts = new Bucket "posts"
# posts.on 'beer', (robj2) -> sys.puts("freshly beered robj: #{sys.inspect(robj2)}")
# 
# RiakObject = require('../lib/riak_object')
# robj = new RiakObject(posts)
# robj.data = {terd: "licks"}
# robj.on 'beer', ->
#   sys.puts("robj: #{sys.inspect(robj)}")
#   robj3 = new RiakObject(posts, robj.key)
#   robj3.on 'beer', -> sys.puts("robj3: #{sys.inspect(robj3)}")
#   robj3.read()
# robj.store()

# Bucket = require('./lib/bucket')
# posts = new Bucket "posts"
# RiakObject = require('./lib/riak_object')
# robj = new RiakObject(posts)
# robj.store()