sys = require 'sys'
http = require 'http'
querystring = require 'querystring'
EventEmitter = require('events').EventEmitter

Errors = 
  400: "Bad Request"
  404: "Not Found"
  412: "Precondition Failed"
  415: "Unsupported Media Type"
  503: "Service Unavailable"

class Client extends EventEmitter
  constructor: ->
    @prefix = '/riak'
    @encoding = 'utf8'
    @client = http.createClient 8098
    @client.on 'error', (exception) =>
      @emit 'barf',
        message: exception.message

  put: (path, headers, data, opts) ->
    @exec 'PUT', path, headers, data, opts

  get: (path, headers, opts)->
    @exec 'GET', path, headers, undefined, opts

  querify: (path, opts) ->
    path = "#{@prefix}#{path}"
    path += "?#{querystring.stringify opts}" if opts?
    path

  error: (response) ->
    status = response.statusCode
    if 400 <= status < 600
      error = new Error "#{status}"
      msg = Errors[status]
      error.message += " #{msg}." if msg?
      error.statusCode = status
      error

  exec: (method, path, headers, opts, data) ->
    path = @querify path, opts
    req = @client.request method, path, headers
    req.write data if data?
    req.end()
    req.on 'response', (res) =>
      res.setEncoding @encoding
      buffer = ''
      res.on 'data', (chunk) -> buffer += chunk
      res.on 'end', =>
        error = @error(res)
        if error?
          @emit 'barf', error
        else
          @emit 'beer',
            statusCode: res.statusCode,
            headers: res.headers
            rawData: buffer

module.exports = Client