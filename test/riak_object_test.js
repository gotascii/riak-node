(function() {
  var Bucket, Client, RiakObject, sys, testCase;
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  sys = require('sys');
  RiakObject = require('../lib/riak_object');
  Bucket = require('../lib/bucket');
  Client = require('../lib/client');
  testCase = require('nodeunit').testCase;
  module.exports = {
    "An robj with a bucket": testCase({
      setUp: function() {
        this.bucket = new Bucket("posts");
        return (this.robj = new RiakObject(this.bucket));
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
        var _drink;
        _drink = this.robj.drink;
        this.robj.drink = __bind(function(beer) {
          assert.equal("beer!", beer);
          assert.done();
          return (this.robj.drink = _drink);
        }, this);
        return this.robj.client.emit('beer', "beer!");
      },
      "should emit barf if client emits barf": function(assert) {
        this.robj.on('barf', function(barf) {
          assert.equal("barf!", barf);
          return assert.done();
        });
        return this.robj.client.emit('barf', "barf!");
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
      }
    })
  };
})();
