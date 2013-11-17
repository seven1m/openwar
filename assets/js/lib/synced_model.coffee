class Backbone.SyncedModel extends Backbone.Model

  initialize: =>
    @sock = @attributes.sock
    delete @attributes.sock
    @sock.on 'sync', (data) =>
      console.log 'got data', data

  # by default, accept all data from other side
  incoming: (attrs) => attrs

  # by default, send raw data to other side
  outgoing: => @attributes

  # sync data to the other side
  sync: (cb) =>
    @send 'sync', @outgoing(), (data) =>
      console.log 'got data in callback', data
      @set(data)
      console.log 'client data is now', @attributes

  send: (method, data, cb) =>
    data =
      class: @class
      data: data
    console.log('sending data from client', method, data)
    @sock.emit(method, data, cb)
