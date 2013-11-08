express = require('express')
connect_assets = require('connect-assets')

app = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use connect_assets()

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'play'

app.listen 3000, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
