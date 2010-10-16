global.sys = require 'sys'
global.Bucket = require '../src/bucket'
global.Client = require '../src/client'
global.EventEmitter = require('events').EventEmitter
global.Robject = require '../src/robject'
global.Resource = require '../src/resource'
global.testCase = require('nodeunit').testCase

stubs = []
module.exports =
  stub: (obj, name, fun) ->
    stubs.push({'obj':obj, 'name':name, 'fun':obj[name]})
    obj[name] = if fun? then fun else ->

  unstub: ->
    for stubbed in stubs
      stubbed.obj[stubbed.name] = stubbed.fun
    stubs.length = 0