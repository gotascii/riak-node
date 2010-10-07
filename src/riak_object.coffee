querystring = require('querystring')

class RiakObject
  constructor: (@opts) ->
    @bucket = @opts.bucket
    @key = @opts.key
    @data = @opts.data
    @method = @opts.method or= 'GET'
    @params = {}
    @params[param] = @opts[param] for param in Meta.queryParams
    @generatePath()
    @encodeData()

  generatePath: ->
    @path = "/riak/#{@bucket}"
    @path += "/#{@key}" if @key?
    @path += "?#{querystring.stringify(@params)}" if @params?
    @path

  encodeData: ->
    if @data?
      @headers = {'Content-Type' : 'application/json'}
      @data = JSON.stringify @data

RiakObject.queryParams = ['w', 'dw', 'returnbody']

module.exports = RiakObject