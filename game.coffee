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
      @connections[id] ?= new Player(id, @, conn)
      cb('connected')
    #if !@players[id] and @playerCount() < @maxPlayers
      #@players[id] = new Player(id, @, conn)
      #@players[id].join()
    #@checkState()

  #join: =>
    #id = conn.conn.id
    #if !@players[id] and @playerCount() < @maxPlayers
      #@players[id] = new Player(id, @, conn)
      #@players[id].join()
    #@checkState()

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
    @conn.on 'data', (msg) ->
      data = JSON.parse(msg)
      if action = @[data.action]
        action(data)

  create: (data) =>
    # TODO only allow name change
    @set(data)

  data: =>
    name: @name
    score: @score
    armies: @armies

  send: (action, data) =>
    data.action = action
    console.log(@id, data)
    @conn.write JSON.stringify(data)


module.exports = Game
