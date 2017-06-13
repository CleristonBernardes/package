_       = require 'underscore'
config  = require 'config'

get_parameters = (req) ->
  _.extend req.params, req.query, req.body

wrapper = (method) ->
  (req, res, next) ->
    params = get_parameters req
    try
      method params, (err, result) ->
        return next err if err?
        res.status(200).send(result)
    catch err
      console.log "Err:", err
      next config.error.message || "Error"

module.exports = {
  get_parameters
  wrapper
}
