var http, querystring, storeKeyless, sys;
http = require('http');
querystring = require('querystring');
storeKeyless = function(bucketName, data, params, handler) {
  var encodedData, httpClient, queryParams, request;
  httpClient = http.createClient(8098);
  queryParams = querystring.stringify(params);
  request = httpClient.request('POST', "/riak/" + (bucketName) + "?" + (queryParams), {
    'Content-Type': 'application/json'
  });
  request.on('response', function(response) {
    response.setEncoding('utf8');
    return response.on('data', function(chunk) {
      return handler(response, chunk);
    });
  });
  encodedData = JSON.stringify(data);
  return request.end(encodedData);
};
sys = require('sys');
storeKeyless("bucket", {
  jack: 'rules'
}, {
  returnbody: 'true'
}, function(response, chunk) {
  sys.puts('STATUS: ' + response.statusCode);
  sys.puts('HEADERS: ' + JSON.stringify(response.headers));
  return sys.puts('BODY: ' + chunk);
});