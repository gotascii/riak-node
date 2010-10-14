(function() {
  var Client, EventEmitter, RiakObject, sys;
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  }, __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
  };
  sys = require('sys');
  Client = require('./client');
  EventEmitter = require('events').EventEmitter;
  RiakObject = function(bucket, key) {
    this.bucket = bucket;
    this.key = key;
    this.path = bucket.path;
    if (typeof key !== "undefined" && key !== null) {
      this.path += ("/" + (key));
    }
    this.contentType = 'application/json';
    this.client = new Client();
    this.client.on('beer', __bind(function(beer) {
      return this.drink(beer);
    }, this));
    this.client.on('barf', __bind(function(barf) {
      return this.emit('barf', barf);
    }, this));
    return this;
  };
  __extends(RiakObject, EventEmitter);
  RiakObject.prototype.headers = function() {
    return {
      'content-type': this.contentType
    };
  };
  RiakObject.prototype.serialize = function() {
    var _a;
    if (typeof (_a = this.data) !== "undefined" && _a !== null) {
      return (this.rawData = JSON.stringify(this.data));
    }
  };
  RiakObject.prototype.deserialize = function() {
    var _a;
    if (typeof (_a = this.rawData) !== "undefined" && _a !== null) {
      return (this.data = JSON.parse(this.rawData));
    }
  };
  RiakObject.prototype.store = function(opts) {
    var _a, method;
    method = (function() {
      if ((typeof (_a = obj.key) === "function" ? _a('put') : undefined)) {

      } else {
        return 'post';
      }
    })();
    this.serialize();
    return this.client[method](this.path, this.headers(), opts, this.rawData);
  };
  RiakObject.prototype.read = function(opts) {
    return this.client.get(this.path, this.headers(), opts);
  };
  RiakObject.prototype.ingest = function(buffer) {
    if ((typeof buffer !== "undefined" && buffer !== null) && buffer !== '') {
      this.rawData = buffer;
      return this.deserialize();
    }
  };
  RiakObject.prototype.drink = function(beer) {
    var _a, headers;
    headers = beer.headers;
    if (typeof (_a = headers.location) !== "undefined" && _a !== null) {
      this.key = headers.location.split("/").pop();
    }
    this.contentType = headers['content-type'];
    this.ingest(beer.buffer);
    this.emit('beer');
    return this.bucket.emit('beer', this);
  };
  module.exports = RiakObject;
})();
