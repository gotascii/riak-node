sys = require 'sys'
Client = require './client'
EventEmitter = require('events').EventEmitter

class RiakObject extends EventEmitter
  constructor: (bucket, key) ->
    @bucket = bucket
    @key = key
    @path = bucket.path
    @path += "/#{key}" if key?
    @contentType = 'application/json'
    @client = new Client
    @client.on 'beer', (beer) -> drink(beer)
    @client.on 'barf', (barf) -> @emit 'barf', barf

  headers: ->
    {'content-type': @contentType}

  store: (opts) ->
    method = if obj.key? 'put' else 'post'
    @serialize()
    @client[method](@path, @headers(), opts, @rawData)

  read: (opts) ->
    @client.get(@path, @headers(), opts)

  drink: (beer) ->
    headers = beer.headers
    @key = headers.location.split("/").pop() if headers.location?
    @contentType = headers['content-type']
    @read beer.buffer
    @emit 'beer'
    @bucket.emit 'beer', this

  read: (buffer) ->
    if buffer? and buffer != ''
      @rawData = buffer
      @deserialize()

  serialize: ->
    @rawData = JSON.stringify @data if @data?

  deserialize: ->
    @data = JSON.parse @rawData if @rawData?

module.exports = RiakObject