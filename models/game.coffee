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
      unless players.get(data.player.id)
        players.add(data.player)
        data.players = players
      delete data.player
    data

  outgoing: =>
    attrs = _.clone(@attributes)
    attrs.players = attrs.players.map (p) ->
      name: p.get('name')
    attrs

module.exports = Game
