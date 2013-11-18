SyncedModel = require('../lib/synced_model')
Player = require('./player')
Backbone = require('backbone')
_ = require('underscore')

class Game extends SyncedModel

  class: 'game'

  initialize: =>
    super
    unless @get('players') instanceof Backbone.Collection
      @set 'players', new Backbone.Collection(@get('players'))
    @get('players').on 'change add remove', =>
      @trigger('change')
  
  incoming: (data) =>
    # TODO whitelist game attrs that client can set
    delete data.players
    if data.player
      players = @get('players')
      p = players.get(data.player.id)
      if data.player.remove
        players.remove(p)
      else if not p
        players.add(data.player)
      data.players = players
      delete data.player
    data

  outgoing: (sessionId) =>
    attrs = _.clone(@attributes)
    attrs.players = attrs.players.map (p) ->
      name: p.get('name')
    player = @get('players').get(sessionId)
    attrs.player = if player then player.attributes else null
    attrs

module.exports = Game
