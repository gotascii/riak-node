(function() {
  var Bucket, EventEmitter, client, sys;
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
  client = require('./client');
  EventEmitter = require('events').EventEmitter;
  Bucket = function(name) {
    this.name = name;
    this.path = ("/" + (name));
    return this;
  };
  __extends(Bucket, EventEmitter);
  Bucket.prototype.read = function(key, opts) {
    var robj;
    robj = new RiakObject(this, key);
    robj.on('loaded', __bind(function() {
      return this.emit('riakObjectLoaded', robj);
    }, this));
    return client.read(robj, opts);
  };
  module.exports = Bucket;
})();
