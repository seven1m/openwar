Backbone = require('backbone')
require('backbone-relational')

class SyncedModel extends Backbone.RelationalModel

  initialize: =>
    sock = @attributes.sock
    delete @attributes.sock
    @connections ?= {}
    sock.on 'connection', (conn) =>
      @connections[conn.id] = conn
      conn.on 'sync', (data, cb) =>
        if data.class == @class
          @set(@incoming(data.data))
          @sync()
      conn.on 'identify', (sessionId, cb) =>
        conn.sessionId = sessionId
        cb()
      conn.on 'disconnect', =>
        delete @connections[conn.id]

  # by default, accept all data from other side
  incoming: (attrs) => attrs

  # by default, send raw data to other side
  outgoing: => @attributes

  # sync data to the other side
  sync: (cb) =>
    for sock_id, sock of @connections
      data =
        class: @class
        data: @outgoing(sock.sessionId)
      sock.emit('sync', data, cb)

  send: (method, data, cb) =>

module.exports = SyncedModel
