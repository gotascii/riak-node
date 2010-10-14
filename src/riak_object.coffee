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
    @client.on 'beer', (beer) => @drink beer
    @client.on 'barf', (barf) => @emit 'barf', barf

  headers: ->
    {'content-type': @contentType}

  serialize: ->
    @rawData = JSON.stringify @data if @data?

  deserialize: ->
    @data = JSON.parse @rawData if @rawData?

  store: (opts) ->
    @serialize()
    method = if @key? 'put' else 'post'
    @client[method] @path, @headers(), opts, @rawData

  read: (opts) ->
    if @key?
      @client.get @path, @headers(), opts
    else
      @emit 'barf',
        message: "Key is undefined. I cannot read without a key."

  ingest: (buffer) ->
    if buffer? and buffer != ''
      @rawData = buffer
      @deserialize()

  drink: (beer) ->
    headers = beer.headers
    @key = headers.location.split("/").pop() if headers.location?
    @contentType = headers['content-type']
    @ingest beer.buffer
    @emit 'beer'
    @bucket.emit 'beer', this

module.exports = RiakObject