class app.views.InfoView extends Backbone.View

  events:
    'click #join': 'join'

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
      <a id='join' class='btn btn-primary'>Join Game</a>
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

  join: =>
    @model.trigger('join')

  playerName: =>
    if player = @model.get('player')
      player.name
