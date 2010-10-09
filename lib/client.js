(function() {
  var client, encoding, prefix;
  client = require('http').createClient(8098);
  prefix = '/riak';
  encoding = 'utf8';
  module.exports = {
    store: function(robj, opts) {
      var _a, method;
      method = (typeof (_a = robj.key) !== "undefined" && _a !== null) ? 'PUT' : 'POST';
      return this.exec(robj, method, opts);
    },
    exec: function(robj, method, opts) {
      var req;
      req = client.request(method, this.getPath(robj, opts), robj.headers);
      robj.write(req);
      req.on('response', function(res) {
        var buffer;
        res.setEncoding(encoding);
        buffer = '';
        res.on('data', function(chunk) {
          return buffer += chunk;
        });
        return res.on('end', function() {
          return robj.emit('load', res.statusCode, res.headers, buffer);
        });
      });
      return req.end();
    },
    getPath: function(robj, opts) {
      var path;
      path = ("" + (prefix) + (robj.path));
      if (typeof opts !== "undefined" && opts !== null) {
        path += ("?" + (querystring.stringify(opts)));
      }
      return path;
    }
  };
})();
