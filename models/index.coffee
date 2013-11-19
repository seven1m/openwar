exports.Game = require('./game')
exports.Player = require('./player')

Backbone = require('backbone-relational')
Backbone.Relational.store.addModelScope(exports)
