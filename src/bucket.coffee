EventEmitter = require('events').EventEmitter

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @path = "/#{name}"

module.exports = Bucket