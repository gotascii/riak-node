querystring = require('querystring')

class Opts
  constructor: (@opts) ->
    @bucket = @opts.bucket
    @key = @opts.key
    @data = @opts.data
    @params = @opts.params
    @method = @opts.method
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
      @data = JSON.stringify(@data)

module.exports = Opts