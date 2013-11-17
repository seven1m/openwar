Backbone = require('backbone')

class SyncedModel extends Backbone.Model

  initialize: =>
    sock = @attributes.sock
    delete @attributes.sock
    @connections ?= {}
    sock.on 'connection', (sock) =>
      @connections[sock.id] = sock
      sock.on 'sync', (data, cb) =>
        if data.class == @class
          @set(@incoming(data.data))
          @sync()
      sock.on 'disconnect', =>
        delete @connections[sock.id]

  # by default, accept all data from other side
  incoming: (attrs) => attrs

  # by default, send raw data to other side
  outgoing: => @attributes

  # sync data to the other side
  sync: (cb) =>
    @send 'sync', @outgoing(), cb

  send: (method, data, cb) =>
    data =
      class: @class
      data: data
    for sock_id, sock of @connections
      sock.emit(method, data, cb)

module.exports = SyncedModel
