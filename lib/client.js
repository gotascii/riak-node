(function() {
  var Client, Errors, EventEmitter, http, querystring, sys;
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
  http = require('http');
  querystring = require('querystring');
  EventEmitter = require('events').EventEmitter;
  Errors = {
    400: "Bad Request - e.g. when r parameter is invalid (> N)",
    404: "Not Found - the object could not be found on enough partitions",
    503: "Service Unavailable - the request timed out internally"
  };
  Client = function() {
    this.prefix = '/riak';
    this.encoding = 'utf8';
    this.client = http.createClient(8098);
    this.client.on('error', __bind(function(exception) {
      return this.emit('barf', {
        message: exception.message
      });
    }, this));
    return this;
  };
  __extends(Client, EventEmitter);
  Client.prototype.put = function(path, headers, data, opts) {
    return this.exec('PUT', path, headers, data, opts);
  };
  Client.prototype.get = function(path, headers, opts) {
    return this.exec('GET', path, headers, undefined, opts);
  };
  Client.prototype.querify = function(path, opts) {
    path = ("" + (this.prefix) + (path));
    if (typeof opts !== "undefined" && opts !== null) {
      path += ("?" + (querystring.stringify(opts)));
    }
    return path;
  };
  Client.prototype.exec = function(method, path, headers, opts, data) {
    var req;
    path = this.querify(path, opts);
    req = this.client.request(method, path, headers);
    if (typeof data !== "undefined" && data !== null) {
      req.write(data);
    }
    req.end();
    return req.on('response', function(res) {
      var buffer;
      res.setEncoding(encoding);
      buffer = '';
      res.on('data', function(chunk) {
        return buffer += chunk;
      });
      return res.on('end', function() {
        var error;
        error = Errors[res.statusCode];
        return (typeof error !== "undefined" && error !== null) ? this.emit('barf', {
          statusCode: res.statusCode,
          message: error
        }) : this.emit('beer', {
          statusCode: res.statusCode,
          headers: res.headers,
          rawData: buffer
        });
      });
    });
  };
  module.exports = Client;
})();
