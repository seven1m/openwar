class Backbone.SyncedModel extends Backbone.Model

  initialize: =>
    @sock = @attributes.sock
    delete @attributes.sock
    @sock.on 'sync', (data) =>
      if data.class == @class
        @set(@incoming(data.data))

  # by default, accept all data from other side
  incoming: (attrs) => attrs

  # by default, send raw data to other side
  outgoing: => @attributes

  # sync data to the other side
  sync: (cb) =>
    @send 'sync', @outgoing(), (data) =>
      @set(data)

  send: (method, data, cb) =>
    data =
      class: @class
      data: data
    @sock.emit(method, data, cb)
