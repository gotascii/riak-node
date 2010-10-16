sys = require 'sys'
Resource = require './resource'
EventEmitter = require('events').EventEmitter

class Robject extends EventEmitter
  constructor: (bucket, key) ->
    @bucket = bucket
    @key = key
    @resource = new Resource this
    @resource.path = bucket.path
    @resource.path += "/#{key}" if key?

  store: (opts) ->
    method = 'post' unless @key?
    @resource.store opts, method

  read: (opts) ->
    if @key?
      @resource.get opts
    else
      @emit 'barf',
        message: "Key is undefined. I cannot read without a key."

  drink: (beer) ->
    @key = beer.headers.location.split("/").pop()
    @resource.drink beer
    @emit 'beer'
    @bucket.emit 'beer', this

module.exports = Robject