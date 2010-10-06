http = require('http')
querystring = require('querystring')

storeKeyless = (bucket, data, params, handler) -> 
  httpClient = http.createClient(8098)
  queryParams = querystring.stringify(params)
  request = httpClient.request('POST', "/riak/#{bucket}?#{queryParams}", {'Content-Type' : 'application/json'})
  request.on('response', (response) ->
    response.setEncoding('utf8')
    response.on('data', (chunk) ->
      handler(response, chunk)
    )
  )
  encodedData = JSON.stringify(data)
  request.end(encodedData)

read = (bucket, key, params, handler) ->
  httpClient = http.createClient(8098)
  queryParams = querystring.stringify(params)
  request = httpClient.request("/riak/#{bucket}/#{key}?#{queryParams}")
  request.on('response', (response) ->
    response.setEncoding('utf8')
    response.on('data', (chunk) ->
      handler(response, chunk)
    )
  )
  request.end()

sys = require('sys')
key = ''
storeKeyless("bucket", {jack: 'rules'}, {returnbody: 'true'}, (response, chunk) ->
  sys.puts('STATUS: ' + response.statusCode)
  sys.puts('HEADERS: ' + JSON.stringify(response.headers))
  sys.puts('BODY: ' + chunk)
  key = response.headers["location"]
)