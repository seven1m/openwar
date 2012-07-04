$ ->
  svg = $('svg')
  $.get 'map.svg', (svgData) ->
    $(svgData).find('svg>*').each ->
      svg.append(this)
    $.getJSON 'map.json', (mapData) ->
      for id, region of mapData.regions
        region.id = id
        region = new Region(region)
        view = new RegionView(model: region, el: svg.find('#' + id))
    .error ->
      alert "error parsing map json: #{arguments[2]}"


class Region extends Backbone.Model

  initialize: ->
    @armies = 0


class RegionView extends Backbone.View

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
    'click': 'select'
    'mouseenter': 'hoverOn'
    'mouseleave': 'hoverOff'

  hoverOn: (e) ->
    @$el.css 'fill', @hoverColor
    console.log @model.id

  hoverOff: (e) ->
    @$el.css 'fill', @vacantColor

  select: (e) ->
    if e.shiftKey
      window.selectedRegion = @model.id
      window.regions[selectedRegion] = []
    else
      window.regions[selectedRegion].push(@model.id)
      console.log(window.regions[selectedRegion])

  render: ->
    # pass

window.regions = {}
window.selectedRegion = null
