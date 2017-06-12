express 							= require "express"
config	 							= require "config"
bodyParser 						= require "body-parser"
package_pre       		= require './presenter/package'
utils						      = require './utils'


app = express()

app.use (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')
  if ('OPTIONS' == req.method)
    res.send 200
  else
    next()
app.use bodyParser.urlencoded { extended: false }
app.use bodyParser.json()
app.use bodyParser.json { type: 'application/vnd.api+json' }

app.get '/', utils.wrapper((p, d) -> d null, "Server running...")
app.get '/api/value', utils.wrapper(package_pre.get_package)


server = app.listen (process.env.PORT || config.server.port || 8080), () ->
  console.log "Service running #{process.env.PORT || config.server.port || 8080}...."
