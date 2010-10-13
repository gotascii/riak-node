(function() {
  var Bucket, RiakObject, sys, testCase;
  sys = require('sys');
  RiakObject = require('../lib/riak_object');
  Bucket = require('../lib/bucket');
  testCase = require('nodeunit').testCase;
  module.exports = {
    testWithBucket: testCase({
      setUp: function() {
        this.posts = new Bucket("posts");
        return (this.robj = new RiakObject(this.posts));
      },
      testHasBucket: function(assert) {
        assert.equal(this.posts, this.robj.bucket);
        return assert.done();
      },
      testHasNoKey: function(assert) {
        assert.equal(undefined, this.robj.key);
        return assert.done();
      },
      testHasPath: function(assert) {
        assert.equal("/posts", this.robj.path);
        return assert.done();
      },
      testDefaultContentTypeJSON: function(assert) {
        assert.equal("application/json", this.robj.contentType);
        return assert.done();
      },
      testDefaultContentTypeJSON: function(assert) {
        assert.equal("application/json", this.robj.contentType);
        return assert.done();
      },
      testGeneratesHeaders: function(assert) {
        assert.deepEqual({
          'content-type': "application/json"
        }, this.robj.headers());
        return assert.done();
      },
      testStoreEmitsBeerOnSelf: function(assert) {
        var test;
        test = this;
        this.robj.on('beer', function() {
          assert.equals(test.robj, this);
          return assert.done();
        });
        return this.robj.store();
      }
    })
  };
})();
