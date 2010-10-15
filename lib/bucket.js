(function() {
  var Bucket, Client, EventEmitter;
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
  EventEmitter = require('events').EventEmitter;
  Client = require('./client');
  Bucket = function(name) {
    this.name = name;
    this.path = ("/" + (name));
    this.client = new Client();
    this.client.on('beer', __bind(function(beer) {
      return this.drink(beer);
    }, this));
    return this;
  };
  __extends(Bucket, EventEmitter);
  module.exports = Bucket;
})();
