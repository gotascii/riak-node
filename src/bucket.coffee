sys = require 'sys'
client = require './client'
RiakObject = require './riak_object'
EventEmitter = require('events').EventEmitter

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @path = "/#{name}"

module.exports = Bucket