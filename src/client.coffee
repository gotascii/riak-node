sys = require('sys')
http = require('http')
client = http.createClient(8098)
Opts = require('./opts')

store = (opts, resHandler) ->
  opts.method = if opts.key? then 'PUT' else 'POST'
  exec(opts, resHandler)

exec = (opts, resHandler) ->
  opts = new Opts(opts)
  req = client.request(opts.method, opts.path, opts.headers)
  req.on('response', (res) ->
    res.setEncoding('utf8')
    res.on('data', (chunk) ->
      resHandler(res, chunk)
    )
  )
  req.write(opts.data) if opts.data?
  req.end()
  sys.puts('done')

# store({
#   bucket: "omfg"
#   data: {terds: "rule"}
#   params: {returnbody: 'true'}
# }, (response, chunk) ->
#   sys.puts('STATUS: ' + response.statusCode)
#   sys.puts('HEADERS: ' + JSON.stringify(response.headers))
#   sys.puts('BODY: ' + chunk)
# )