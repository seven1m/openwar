class app.models.Game extends Backbone.SyncedModel

  class: 'game'

  relations: [
    {
      type: Backbone.HasMany,
      key: 'players',
      relatedModel: 'app.models.Player',
      collectionType: Backbone.Collection,
    },
    {
      type: Backbone.HasOne,
      key: 'player',
      relatedModel: 'app.models.Player'
    }
  ]
