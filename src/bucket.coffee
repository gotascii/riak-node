sys = require 'sys'
client = require './client'
EventEmitter = require('events').EventEmitter

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @path = "/#{name}"

  read: (key, opts) ->
    robj = new RiakObject(this, key)
    robj.on 'loaded', =>
      @emit 'riakObjectLoaded', robj
    client.read(robj, opts)

module.exports = Bucket