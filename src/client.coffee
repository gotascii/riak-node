sys = require 'sys'
http = require 'http'
client = http.createClient 8098
RiakObject = require './riak_object'

get = (opts, resHandler) ->
  exec opts, resHandler

store = (opts, resHandler) ->
  opts.method = 'POST'
  exec opts, resHandler

exec = (opts, resHandler) ->
  robj = new RiakObject opts
  req = client.request robj.method, robj.path, robj.headers
  req.on 'response', (res) ->
    res.setEncoding 'utf8'
    res.on 'data', (chunk) ->
      resHandler res, chunk
  req.write robj.data if robj.data?
  req.end()
  sys.puts 'done'

# get({
#   bucket: "omfg",
#   key: "terds"
# })

# store({
#   bucket: "omfg"
#   data: {terds: "rule"}
#   returnbody: 'true'
# }, (response, chunk) ->
#   sys.puts('STATUS: ' + response.statusCode)
#   sys.puts('HEADERS: ' + JSON.stringify(response.headers))
#   sys.puts('BODY: ' + chunk)
# )