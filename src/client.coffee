sys = require 'sys'
client = require('http').createClient 8098
prefix = '/riak'
encoding = 'utf8'

module.exports =
  store: (robj, opts) ->
    method = if robj.key? then 'PUT' else 'POST'
    @exec(robj, method, opts)

  read: (robj, opts) ->
    @exec(robj, 'GET', opts)

  exec: (robj, method, opts) ->
    req = client.request method, @getPath(robj, opts), robj.headers()
    robj.write(req)
    req.on 'response', (res) ->
      res.setEncoding encoding
      buffer = ''
      res.on 'data', (chunk) -> buffer += chunk
      res.on 'end', ->
        robj.load(res.statusCode, res.headers, buffer)
    req.end()

  getPath: (robj, opts) ->
    path = "#{prefix}#{robj.path}"
    path += "?#{querystring.stringify(opts)}" if opts?
    path