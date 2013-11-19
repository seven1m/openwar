SyncedModel = require('../lib/synced_model')
Player = require('./player')
Backbone = require('backbone')
_ = require('underscore')

class Game extends SyncedModel

  class: 'game'

  relations: [
    {
      type: Backbone.HasMany,
      key: 'players',
      relatedModel: 'Player',
      collectionType: Backbone.Collection,
    },
    {
      type: Backbone.HasOne,
      key: 'player',
      relatedModel: 'Player'
    }
  ]

  initialize: =>
    super
    #unless @get('players') instanceof Backbone.Collection
      #@set 'players', new Backbone.Collection(@get('players'))
    if players = @get('players')
      players.on 'change add remove', =>
        @trigger('change')
  
  incoming: (data) =>
    # TODO whitelist game attrs that client can set
    delete data.players
    if id = data.remove_player
      p = @get('players').get(id)
      @get('players').remove(p)
      data.remove_player = null
    else if data.player
      @get('players').add(data.player)
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
