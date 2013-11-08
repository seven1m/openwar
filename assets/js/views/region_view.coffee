class app.views.RegionView extends Backbone.View

  vacantColor: '#ccc'
  hoverColor: '#777'
  circleRadius: 10

  initialize: (options) ->
    @id = options.id
    @center = @model.get('center')
    @map = $('#map')

  events:
    'mouseenter': 'hoverOn'
    'mouseleave': 'hoverOff'

  hoverOn: (e) =>
    @$el.css 'fill', @hoverColor

  hoverOff: (e) =>
    @$el.css 'fill', @vacantColor

  buildRect: ->
    width = if @text.textContent.length > 2 then 30 else 20
    @rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect')
    @rect.setAttribute('x', @center[0] - (width / 2))
    @rect.setAttribute('y', @center[1] - 10)
    @rect.setAttribute('width', width)
    @rect.setAttribute('height', 20)
    @rect.setAttribute('rx', 5)
    @rect.setAttribute('ry', 5)
    @rect.setAttribute('style', 'fill:#aaa')
    @rect.setAttribute('id', @id + '-rect')
    $(@rect).on 'mouseenter', @hoverOn
    $(@rect).on 'mouseleave', @hoverOff
    @map[0].insertBefore(@rect, @text)

  showArmies: ->
    unless @text
      @text = document.createElementNS('http://www.w3.org/2000/svg', 'text')
      @text.setAttribute('x', @center[0])
      @text.setAttribute('y', @center[1] + 5)
      @text.setAttribute('text-anchor', 'middle')
      @text.setAttribute('style', 'fill: #fff')
      @map[0].appendChild(@text)
      $(@text).on 'mouseenter', @hoverOn
      $(@text).on 'mouseleave', @hoverOff
    @text.textContent = @model.get('armies')
    unless @rect
      @buildRect()

  render: ->
    @showArmies()
    #@recordCenter()

  # to set the center of each region:
  # 1. uncomment @recordCenter() above and load the map
  # 2. click in the center of each region
  # 3. in the js console:
  #    app.map.addCenters()
  #    JSON.stringify(app.map.meta)
  # 4. paste JSON into map.json and save
  recordCenter: ->
    @$el.click (e) =>
      if rect = @map[0].querySelector('#' + @id + '-rect')
        rect.remove()
      else
        x = e.clientX - @map.position().left
        y = e.clientY - @map.position().top
        @center = [x, y]
        @buildRect()

