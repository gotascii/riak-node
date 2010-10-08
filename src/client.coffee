sys = require 'sys'
http = require 'http'
RiakObject = require './riak_object'

class Client
  constructor: ->
    @prefix = '/riak'
    @client = http.createClient 8098

  store: (robj, opts, handler) ->
    querystring.stringify(opts)
    method = if robj.key? then 'PUT' else 'POST'
    path = "#{@prefix}#{robj.path}"
    exec(robj, method, path, opts, handler)

  exec: (robj, method, path, opts, handler) ->
    if typeof opts == 'function'
      handler = opts
      opts = undefined
    path = "#{path}?#{querystring.stringify(opts)}" if opts?
    req = @client.request method, path, robj.headers
    req.write robj.encodedData() if robj.data?
    buffer = ''
    req.on 'response', (res) ->
      res.setEncoding 'utf8'
      res.on 'data', (chunk) -> buffer += chunk
      res.on 'end', ->
        # load response into robj
        # call handler pass along robj
        # handle errors in some way
    req.end()

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