class RiakObject
  constructor: (bucket, key, contentType) ->
    @bucket = bucket
    @key = key
    @path = "/#{bucket}"
    @path = "#{@path}/#{key}" if key?
    @contentType = contentType if contentType? else 'application/json'

  headers: ->
    'Content-Type': @contentType
  
  encodedData: ->
    JSON.stringify @data if @data?

module.exports = RiakObject