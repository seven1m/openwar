Backbone = require('backbone')

class SyncedModel extends Backbone.Model

  initialize: =>
    sock = @attributes.sock
    delete @attributes.sock
    sock.on 'connection', (@sock) =>
      @sock.on 'sync', (data, cb) =>
        if data.class == @class
          rconsole.log 'got data', data
          @set(@incoming(data.data))
          rconsole.log 'data is now', @attributes
          cb @outgoing()

  # by default, accept all data from other side
  incoming: (attrs) => attrs

  # by default, send raw data to other side
  outgoing: => @attributes

  # sync data to the other side
  sync: (cb) =>
    @send 'sync', @outgoing(), cb

  send: (method, data, cb) =>
    console.log('sending data from server', method, data)
    @sock.emit(method, data, cb)

module.exports = SyncedModel
