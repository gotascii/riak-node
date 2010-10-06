var Opts, client, exec, http, store, sys;
sys = require('sys');
http = require('http');
client = http.createClient(8098);
Opts = require('./opts');
store = function(opts, resHandler) {
  var _a;
  opts.method = (typeof (_a = opts.key) !== "undefined" && _a !== null) ? 'PUT' : 'POST';
  return exec(opts, resHandler);
};
exec = function(opts, resHandler) {
  var _a, req;
  opts = new Opts(opts);
  req = client.request(opts.method, "/riak/" + (opts.path) + "?" + (opts.querystring), opts.headers);
  req.on('response', function(res) {
    res.setEncoding('utf8');
    return res.on('data', function(chunk) {
      return resHandler(res, chunk);
    });
  });
  if (typeof (_a = opts.data) !== "undefined" && _a !== null) {
    req.write(opts.data);
  }
  req.end();
  return sys.puts('done');
};
store({
  bucket: "omfg",
  data: {
    terds: "rule"
  },
  params: {
    returnbody: 'true'
  }
}, function(response, chunk) {
  sys.puts('STATUS: ' + response.statusCode);
  sys.puts('HEADERS: ' + JSON.stringify(response.headers));
  return sys.puts('BODY: ' + chunk);
});