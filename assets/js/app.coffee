window.app =
  models: {}
  views: {}
  DEBUG: true

# TODO move this into a dedicated class of some sort
# maybe a Router???
$ ->
  if $('#map')[0]
    gameId = location.href.replace(/.*\//, '')
    sock = io.connect('/' + gameId)
    sock.on 'log', (data) ->
      console.log.apply(console, data)

    sessionId = $('head').data('session-id')

    player = new app.models.Player
      id: sessionId
      sock: sock

    game = new app.models.Game(
      id: gameId
      sock: sock
    )

    game.on 'join', (data) =>
      player.set('name', data.name)
      game.set('player', player)
      game.sync()

    game.on 'leave', =>
      game.set 'player',
        id: sessionId
        remove: true
      game.sync()

    map = new app.views.MapView
      el: $('#map')
      ui_url: "/maps/usa.svg"
      meta_url: "/maps/usa.json"
    map.on 'ready', map.render

    info = new app.views.InfoView
      el: $('#info')
      model: game

    game.on 'change', ->
      map.render()
      info.render()
    player.on 'change', ->
      map.render()
      info.render()

    sock.on 'connect', =>
      sock.emit 'identify', sessionId, =>
        game.sync()

    app.game = game
