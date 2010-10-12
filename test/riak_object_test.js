(function() {
  var Bucket, RiakObject, sys, testCase;
  sys = require('sys');
  RiakObject = require('../lib/riak_object');
  Bucket = require('../lib/bucket');
  testCase = require('nodeunit').testCase;
  module.exports = testCase({
    setUp: function() {
      this.posts = new Bucket("posts");
      return (this.robj = new RiakObject(this.posts));
    },
    testLoadEmitsBeerOnBucket: function(assert) {
      var test;
      test = this;
      this.posts.on('beer', function(robj) {
        assert.equals(test.robj, robj);
        return assert.done();
      });
      return this.robj.store();
    },
    testLoadEmitsBeerOnSelf: function(assert) {
      var test;
      test = this;
      this.robj.on('beer', function() {
        assert.equals(test.robj, this);
        return assert.done();
      });
      return this.robj.store();
    }
  });
})();
