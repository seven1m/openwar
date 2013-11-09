class app.views.MapView extends Backbone.View

  initialize: =>
    # fetch the map and meta info
    d3.text @options.ui_url, (err, svg) =>
      @markup = svg
      d3.json @options.meta_url, (err, meta) =>
        @meta = meta
        r.armies ?= 0 for id, r of @meta.regions
        @trigger 'ready'

  render: =>
    @$el.append(@markup) if @$el.html() == ''
    @svg = d3.select(@$el.find('svg')[0])
    @svg.attr('width', @meta.geometry.width)
        .attr('height', @meta.geometry.height)
    regions = (region for id, region of @meta.regions)
    @svg.selectAll('rect')
        .data(regions)
        .enter().append('rect')
          .attr('width', (d) -> if new String(d.armies).length > 2 then 30 else 20)
          .attr('height', 20)
          .attr('x', (d) -> d.center[0] - (if new String(d.armies).length > 2 then 15 else 10))
          .attr('y', (d) -> d.center[1] - 10)
          .attr('rx', 5)
          .attr('ry', 5)
          .attr('style', 'fill:#aaa')
    @svg.selectAll('text.army-count')
        .data(regions)
        .enter().append('text')
          .classed('army-count', true)
          .attr('x', (d) -> d.center[0])
          .attr('y', (d) -> d.center[1] + 4)
          .attr('text-anchor', 'middle')
          .attr('style', 'fill:#fff')
          .text((d) -> d.armies)
