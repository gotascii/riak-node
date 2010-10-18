sys = require 'sys'
Client = require './client'

class Resource
  constructor: (entity) ->
    @contentType = 'application/json'
    @client = new Client
    @client.on 'beer', (beer) =>
      @drink beer
      entity.drink beer
    @client.on 'barf', (error) ->
      msg = entity.error(error.statusCode)
      error.message += " #{msg}." if msg?
      entity.emit 'barf', error
    @__defineGetter__ 'path', -> entity.path
    entity.__defineGetter__ 'data', => @data

  headers: ->
    {'content-type': @contentType}

  serialize: ->
    @rawData = JSON.stringify @data if @data?

  deserialize: ->
    @data = JSON.parse @rawData if @rawData?

  store: (opts, method) ->
    method = 'put' unless method?
    @serialize()
    @client[method] @path, @headers(), opts, @rawData

  get: (opts) ->
    @client.get @path, @headers(), opts

  ingest: (buffer) ->
    if buffer? and buffer != ''
      @rawData = buffer
      @deserialize()

  drink: (beer) ->
    @contentType = beer.headers['content-type']
    @ingest beer.buffer

module.exports = Resource