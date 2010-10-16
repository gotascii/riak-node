sys = require 'sys'
EventEmitter = require('events').EventEmitter
Resource = require './resource'

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @resource = new Resource this
    @resource.path = "/#{name}"

module.exports = Bucket