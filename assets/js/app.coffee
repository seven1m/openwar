window.app =
  models: {}
  views: {}

$ ->
  map = new app.views.MapView
    el: $('#map')
    ui_url: "/maps/usa.svg"
    meta_url: "/maps/usa.json"
  map.on 'ready', map.render
  window.app.map = map
