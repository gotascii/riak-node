(function() {
  var Bucket, Client, RiakObject, helper, sys, testCase;
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  sys = require('sys');
  RiakObject = require('../lib/riak_object');
  Bucket = require('../lib/bucket');
  Client = require('../lib/client');
  helper = require('./helper');
  testCase = require('nodeunit').testCase;
  module.exports = {
    "An robj with a bucket": testCase({
      setUp: function() {
        this.bucket = new Bucket("posts");
        return (this.robj = new RiakObject(this.bucket));
      },
      tearDown: function() {
        return helper.unstub();
      },
      "should have a bucket": function(assert) {
        assert.equal(this.bucket, this.robj.bucket);
        return assert.done();
      },
      "should not have a key": function(assert) {
        assert.equal(undefined, this.robj.key);
        return assert.done();
      },
      "should have a path that matches the bucket path": function(assert) {
        assert.equal(this.bucket.path, this.robj.path);
        return assert.done();
      },
      "should have a contentType of application/json": function(assert) {
        assert.equal("application/json", this.robj.contentType);
        return assert.done();
      },
      "should have a client": function(assert) {
        assert.ok(this.robj.client instanceof Client);
        return assert.done();
      },
      "should drink beer if client emits beer": function(assert) {
        helper.stub(this.robj, 'drink', __bind(function(beer) {
          return assert.equal("beer!", beer);
        }, this));
        this.robj.client.emit('beer', "beer!");
        assert.expect(1);
        return assert.done();
      },
      "should emit barf if client emits barf": function(assert) {
        this.robj.on('barf', function(barf) {
          return assert.equal("barf!", barf);
        });
        this.robj.client.emit('barf', "barf!");
        assert.expect(1);
        return assert.done();
      },
      "should generate headers": function(assert) {
        assert.deepEqual({
          'content-type': "application/json"
        }, this.robj.headers());
        return assert.done();
      },
      "should JSON.stringify data into rawData": function(assert) {
        this.robj.data = {
          chug: "brew"
        };
        this.robj.serialize();
        assert.equal("{\"chug\":\"brew\"}", this.robj.rawData);
        return assert.done();
      },
      "should not JSON.stringify data into rawData if there is no data": function(assert) {
        this.robj.rawData = "brewtownusa";
        this.robj.data = undefined;
        this.robj.serialize();
        assert.equal("brewtownusa", this.robj.rawData);
        return assert.done();
      },
      "should JSON.parse rawData into data": function(assert) {
        this.robj.rawData = "{\"beers\":10}";
        this.robj.deserialize();
        assert.deepEqual({
          beers: 10
        }, this.robj.data);
        return assert.done();
      },
      "should not JSON.parse rawData into data if there is no rawData": function(assert) {
        this.robj.data = {
          beers: 10
        };
        this.robj.rawData = undefined;
        this.robj.deserialize();
        assert.deepEqual({
          beers: 10
        }, this.robj.data);
        return assert.done();
      },
      "should serialize on store": function(assert) {
        helper.stub(this.robj, 'serialize', function() {
          return assert.ok(true);
        });
        helper.stub(this.robj.client, 'post');
        this.robj.store();
        assert.expect(1);
        return assert.done();
      },
      "should call client post with path, headers, opts, and rawData": function(assert) {
        this.robj.rawData = "rawData!";
        this.robj.path = '/path';
        helper.stub(this.robj, 'serialize');
        helper.stub(this.robj, 'headers', function() {
          return {
            header: "value"
          };
        });
        helper.stub(this.robj.client, 'post', function(path, headers, opts, data) {
          assert.equal('/path', path);
          assert.deepEqual({
            header: "value"
          }, headers);
          assert.deepEqual({
            option: "value"
          }, opts);
          return assert.equal('rawData!', data);
        });
        this.robj.store({
          option: "value"
        });
        assert.expect(4);
        return assert.done();
      }
    })
  };
})();
