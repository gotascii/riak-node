sys = require 'sys'
client = require './client'
EventEmitter = require('events').EventEmitter

class RiakObject extends EventEmitter
  constructor: (bucket, key) ->
    @bucket = bucket
    @key = key
    @path = bucket.path
    @path += "/#{key}" if key?
    @contentType = 'application/json'

  headers: ->
    {'content-type': @contentType}

  read: (opts) ->
    client.read(this, opts)

  load: (statusCode, headers, buffer) ->
    @key = headers.location.split("/").pop() if headers.location?
    @contentType = headers['content-type']
    unless buffer == ''
      @rawData = buffer
      @deserialize()
    # beer for all
    @emit 'beer'
    @bucket.emit 'beer', this

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

module.exports = RiakObject