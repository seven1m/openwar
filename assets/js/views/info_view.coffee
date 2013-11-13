class app.views.InfoView extends Backbone.View

  templates:
    players: Handlebars.compile("""
      <table>
        {{#each players}}
        <tr>
          <td>{{name}}</td>
          <td>{{armies}}</td>
        </tr>
        {{/each}}
      </table>
    """)

  render: =>
    @$el.find('#player .name').html(@playerName())
    @$el.find('#state').html(
      @model.get('state')
    )
    @$el.find('#players').html(
      @templates.players(players: @model.get('players'))
    )
    @

  playerName: =>
    if player = @model.get('player')
      player.name
