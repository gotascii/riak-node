var Opts, querystring;
querystring = require('querystring');
Opts = function(_a) {
  this.opts = _a;
  this.path = this.opts.path;
  this.bucket = this.opts.bucket;
  this.key = this.opts.key;
  this.data = this.opts.data;
  this.params = this.opts.params;
  this.method = this.opts.method;
  this.generatePath();
  this.encodeData();
  this.generateQuerystring();
  return this;
};
Opts.prototype.generatePath = function() {
  var _a;
  this.path = ("/" + (this.bucket));
  if (typeof (_a = this.key) !== "undefined" && _a !== null) {
    return (this.path = ("" + (this.path) + "/" + (this.key)));
  }
};
Opts.prototype.encodeData = function() {
  var _a;
  if (typeof (_a = this.data) !== "undefined" && _a !== null) {
    this.headers = {
      'Content-Type': 'application/json'
    };
    return (this.data = JSON.stringify(this.data));
  }
};
Opts.prototype.generateQuerystring = function() {
  return (this.querystring = querystring.stringify(this.params));
};
module.exports = Opts;