sys = require 'sys'
Client = require './client'

class Resource
  constructor: (entity) ->
    @contentType = 'application/json'
    @client = new Client
    @encoding = 'utf8'
    @client.on 'data', (chunk) => @buffer = chunk
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

  ingest: ->
    sys.puts 'hiho'
    if @buffer?
      @rawData = @buffer.toString @encoding
      @deserialize()
      delete @buffer

  drink: (beer) ->
    @contentType = beer.headers['content-type']
    @ingest
    sys.puts 'hi'

module.exports = Resource