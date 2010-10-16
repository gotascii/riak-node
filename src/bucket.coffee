sys = require 'sys'
EventEmitter = require('events').EventEmitter
Resource = require './resource'

class Bucket extends EventEmitter
  constructor: (name) ->
    @name = name
    @path = "/#{name}"
    @resource = new Resource this

  store: (opts) ->
    @resource.store opts

  read: (opts) ->
    @resource.get opts

module.exports = Bucket

# {"props":
#   {"name":"test",
#   "n_val":3,
#   "allow_mult":false,
#   "last_write_wins":false,
#   "precommit":[],
#   "postcommit":[],
#   "chash_keyfun":
#     {"mod":"riak_core_util",
#     "fun":"chash_std_keyfun"},
#   "linkfun":
#     {"mod":"riak_kv_wm_link_walker",
#     "fun":"mapreduce_linkfun"},
#   "old_vclock":86400,
#   "young_vclock":20,
#   "big_vclock":50,
#   "small_vclock":10,
#   "r":"quorum",
#   "w":"quorum",
#   "dw":"quorum",
#   "rw":"quorum"}
# }