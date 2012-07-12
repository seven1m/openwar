class app.views.RegionView extends Backbone.View

  vacantColor: '#ccc'
  hoverColor: '#777'

  path: ->
    @$el.attr('d')

  points: ->
    p.split(',') for p in @path().replace(/^M|z$/, '').split(' ')

  center: ->
    points = @points()
    x = _.compact(parseFloat(p[0]) for p in points)
    y = _.compact(parseFloat(p[1]) for p in points)
    sumX = _.reduce x, (sum, v) -> sum + v
    sumY = _.reduce y, (sum, v) -> sum + v
    [sumX / x.length, sumY / y.length]

  events:
    'mouseenter': 'hoverOn'
    'mouseleave': 'hoverOff'

  hoverOn: (e) ->
    @$el.css 'fill', @hoverColor
    console.log @model.id

  hoverOff: (e) ->
    @$el.css 'fill', @vacantColor

  render: ->

