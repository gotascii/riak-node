sys = require 'sys'
client = require './client'
EventEmitter = require('events').EventEmitter

class RiakObject extends EventEmitter
  constructor: (bucket, key) ->
    @bucket = bucket
    @key = key
    @path = "/#{bucket}"
    @path += "/#{key}" if key?
    @headers = {'Content-Type': 'application/json'}

  load: (statusCode, headers, buffer) ->
    @key = headers.location.split("/").pop() if headers.location?
    unless buffer == ''
      @rawData = buffer
      @deserialize()
    @emit 'loaded'

  serialize: ->
    @rawData = JSON.stringify @data if @data?

  deserialize: ->
    @data = JSON.parse @rawData if @rawData?

  write: (req) ->
    if @data?
      @serialize()
      req.write @rawData

  store: (opts) ->
    client.store(this, opts)

  on: (event, listener) ->
    super event, (args...) ->
      listener.apply(this, args)

module.exports = RiakObject

# sys = require 'sys'
# c = require('./lib/client')
# RiakObject = require('./lib/riak_object')
# robj = new RiakObject("posts")
# robj.data = {terd: "licks"}
# robj.on 'loaded', -> sys.puts(sys.inspect(this))
# robj.store()