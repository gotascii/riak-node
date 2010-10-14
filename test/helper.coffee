stubs = []
module.exports =
  stub: (obj, name, fun) ->
    stubs.push({'obj':obj, 'name':name, 'fun':obj[name]})
    obj[name] = if fun? then fun else ->

  unstub: ->
    for stubbed in stubs
      stubbed.obj[stubbed.name] = stubbed.fun
    stubs.length = 0