class app.views.GameView extends Backbone.View

  initialize: (options) ->
    @sessionId = options.sessionId
    @sock = io.connect('/' + @model.get('id'))
    @setupMap()
    @setupInfo()

  setupMap: =>
    @map = new app.views.MapView
      el: $('#map')
      ui_url: "/maps/usa.svg"
      meta_url: "/maps/usa.json"
    @map.on 'ready', @map.render

  setupInfo: =>
    @info ?= new app.views.InfoView
      el: $('#info')
      model: @model
    @info.render()
    @model.on 'change', @setupInfo
    @model.on 'join', @join

  join: =>
    @sock.emit 'join', (state) =>
      @model.set 'state', state
      @info.render()

  render: =>
    @sock.on 'connect', =>
      console.log('connection established')
      @sock.emit 'connected', sessionId: @sessionId, (state) =>
        @model.set 'state', state
        @info.render()
    @
