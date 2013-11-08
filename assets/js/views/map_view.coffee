class app.views.MapView extends Backbone.View

  initialize: =>
    # fetch the map and meta info
    $.ajax
      url: @options.ui_url
      cache: false
      success: @update
      error: (_, e) => alert "error getting map svg: #{e}"
    $.ajax
      url: @options.meta_url
      dataType: 'json'
      cache: false
      success: @update
      error: (_, e) => alert "error parsing map json: #{e}"

  # store map and meta info
  update: (doc, status, result) =>
    if result.responseXML # svg
      @svg = doc
      $(doc).find('svg>*').each (i, e) =>
        @$el.append(e)
    else # json
      @meta = doc
    if @meta and @svg
      @trigger 'ready'

  render: =>
    @$el.width(@meta.geometry.width)
       .height(@meta.geometry.height)
    @regions = {}
    for id, region of @meta.regions
      region.id = id
      region = new app.models.Region(region)
      region.set('armies', 0)
      view = new app.views.RegionView
        model: region
        el: @$el.find('#' + id)
        id: id
      view.render()
      @regions[id] = view

  addCenters: =>
    for id, info of @meta.regions
      info.center = @regions[id].center
