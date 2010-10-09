(function() {
  var EventEmitter, RiakObject, client, sys;
  var __slice = Array.prototype.slice, __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
  };
  sys = require('sys');
  client = require('./client');
  EventEmitter = require('events').EventEmitter;
  RiakObject = function(bucket, key) {
    this.bucket = bucket;
    this.key = key;
    this.path = ("/" + (bucket));
    if (typeof key !== "undefined" && key !== null) {
      this.path += ("/" + (key));
    }
    this.headers = {
      'Content-Type': 'application/json'
    };
    this.on('load', this.loadListener);
    return this;
  };
  __extends(RiakObject, EventEmitter);
  RiakObject.prototype.loadListener = function(statusCode, headers, buffer) {
    var _a;
    if (typeof (_a = headers.location) !== "undefined" && _a !== null) {
      this.key = headers.location.split("/").pop;
    }
    if (buffer !== '') {
      this.rawData = buffer;
      this.deserialize();
    }
    return this.emit('stored');
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
  RiakObject.prototype.write = function(req) {
    var _a;
    if (typeof (_a = this.data) !== "undefined" && _a !== null) {
      this.serialize();
      return req.write(this.rawData);
    }
  };
  RiakObject.prototype.store = function(opts) {
    return client.store(this, opts);
  };
  RiakObject.prototype.on = function(event, listener) {
    return RiakObject.__super__.on.call(this, event, function() {
      var args;
      args = __slice.call(arguments, 0);
      return listener.apply(this, args);
    });
  };
  module.exports = RiakObject;
})();
