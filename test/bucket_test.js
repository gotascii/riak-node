(function() {
  var Bucket, testCase;
  Bucket = require('../lib/bucket');
  testCase = require('nodeunit').testCase;
  module.exports = testCase({
    setUp: function() {
      return (this.posts = new Bucket("posts"));
    },
    testBucketName: function(assert) {
      assert.equals(this.posts.name, "posts");
      return assert.done();
    },
    testBucketPath: function(assert) {
      assert.equals(this.posts.path, "/posts");
      return assert.done();
    }
  });
})();
