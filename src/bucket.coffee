EventEmitter = require('events').EventEmitter
Client = require './client'

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @path = "/#{name}"
    @client = new Client
    @client.on 'beer', (beer) => @drink beer

module.exports = Bucket