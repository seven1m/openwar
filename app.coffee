express = require('express')
connect_assets = require('connect-assets')
redis = require('redis')
socketio = require('socket.io')
http = require('http')
path = require('path')
crypto = require('crypto')
Game = require('./game')

day = 24 * 60 * 60 * 1000

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.logger('dev')
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.cookieSession(secret: 'your secret', cookie: {maxAge: 365 * day})
app.use (req, res, next) ->
  req.session.id ?= crypto.randomBytes(20).toString('hex')
  res.locals.sessionId = req.session.id
  next()
app.use app.router
app.use connect_assets()
app.use require('stylus').middleware(path.join(__dirname, 'public'))
app.use express.static(path.join(__dirname, 'public'))

if 'development' == app.get('env')
  app.use express.errorHandler()

db = redis.createClient()

app.get '/', (req, res) ->
  res.render 'index',
    newGameId: crypto.randomBytes(20).toString('hex')

server = http.createServer(app)
server.listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')

io = socketio.listen(server)

games = {}
app.get '/play/:id', (req, res) ->
  gameId = req.params.id
  games[gameId] ?= new Game(gameId, db, io.of('/' + gameId))
  res.render 'play'
