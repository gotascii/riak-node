(function() {
  var Bucket, EventEmitter;
  var __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
  };
  EventEmitter = require('events').EventEmitter;
  Bucket = function(name) {
    this.name = name;
    this.path = ("/" + (name));
    return this;
  };
  __extends(Bucket, EventEmitter);
  module.exports = Bucket;
})();
