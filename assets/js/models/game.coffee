class app.models.Game extends Backbone.SyncedModel

  class: 'game'

  incoming: (data) =>
    if data.player and data.player not instanceof app.models.Player
      if d = data.player
        d.sock = @sock
        data.player = new app.models.Player(d)
    data
