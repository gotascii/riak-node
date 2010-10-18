sys = require 'sys'
Resource = require './resource'
EventEmitter = require('events').EventEmitter

class Robject extends EventEmitter
  constructor: (bucket, key) ->
    @bucket = bucket
    @key = key
    @path = bucket.path
    @path += "/#{key}" if key?
    @resource = new Resource this

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
    @emit 'beer'
    @bucket.emit 'beer', this

module.exports = Robject