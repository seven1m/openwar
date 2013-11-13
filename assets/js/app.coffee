window.app =
  models: {}
  views: {}
  DEBUG: true

$ ->
  if $('#map')[0]
    game = new app.models.Game(
      id: location.href.replace(/.*\//, '')
      state: 'connecting'
      players: []
    )
    app.main = new app.views.GameView(
      model: game
      sessionId: $('head').data('session-id')
    ).render()
