request           = require "request"
config            = require 'config'
node_cache        = require "node-cache"
async             = require "async"

cache = new node_cache( { checkperiod: config.api.cache_time } ); #30min

get_all_public_offers = (done) ->
  url = config.api.url
  options = {url, method: 'GET', json: true}

  cache.get url, (err, value) ->
    if not err? && value?
      done null, value
    else
      async.waterfall [
        (n) -> request options, (err, response, body) ->
          return n(err || body?.message || config.error.message) if err? || body?.status isnt config.api.status.success || not body?
          n err, body
        (body, n) -> cache.set url, body, (err, result) ->
          console.error "Error while caching api result: API - #{url} ERROR - #{err}" if err?
          n err, body
        ], done

clean_cache = ({}, done) ->
  cache.del config.api.url, (err, count) ->
    done err, "Cached cleaned successfully."

module.exports = {
  get_all_public_offers,
  clean_cache
}
