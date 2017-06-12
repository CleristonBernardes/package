_ = require 'underscore'

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
      next "We are facing some technical problems, please try again later..."

module.exports = {
  get_parameters
  wrapper
}
