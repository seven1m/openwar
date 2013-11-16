class Game

  maxPlayers: 4
  minPlayers: 2

  constructor: (@id, @db, @sock, cb) ->
    @connections = {}
    @players = {}
    @state = 'waiting'
    @sock.on 'connection', @connect

  connect: (conn) =>
    conn.on 'connected', (data, cb) =>
      id = data.sessionId
      @connections[id] = new Player(id, @, conn)
      console.log(@players)
      if @players[id]
        cb('joined')
      else
        cb('watching')

  playerCount: =>
    Object.keys(@players).length

  checkState: =>
    if @state == 'waiting'
      if @playerCount() >= @minPlayers
        @state = 'ready'
    @send 'state',
      state: @state
      players: (p.data() for id, p of @players)

  send: (action, data) =>
    for id, player of @players
      player.send(action, data)


class Player

  constructor: (@id, @game, @conn) ->
    @name = "Player #{@game.playerCount() + 1}"
    @score = 0
    @armies = 0
    @conn.on 'join', (cb) =>
      @game.players[@id] = @
      console.log(@game.players)
      cb('joined')

module.exports = Game
