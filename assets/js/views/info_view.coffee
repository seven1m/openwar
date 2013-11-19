class app.views.InfoView extends Backbone.View

  events:
    'submit #join-form': 'join'
    'click #join': 'join'
    'click #leave': 'leave'

  templates:
    info: Handlebars.compile """
      <h2>{{player.name}}</h2>
      <p>Status: {{status}}</p>
      <p>Players:</p>
      <table>
        {{#each players}}
        <tr>
          <td>{{name}}</td>
          <td>{{armies}}</td>
        </tr>
        {{/each}}
      </table>
      {{#unless players}}
        <p><em>no one has joined yet</em></p>
      {{/unless}}
      {{#if player}}
        <a id='leave' class='btn btn-danger'>Leave Game</a>
      {{else}}
        <form id='join-form'>
          <input id="name" name="name" placeholder="Your Name"/>
          <a id='join' class='btn btn-primary'>Join Game</a>
        </form>
      {{/if}}
    """

  render: =>
    player = @model.get('player')
    @$el.html(
      @templates.info
        status: @model.get('status')
        players: @model.get('players').toJSON()
        player: player and player.attributes
    )
    @

  join: =>
    @model.trigger 'join',
      name: @$el.find('#name').val()

  leave: =>
    if confirm('Click OK to leave this game.')
      @model.trigger 'leave'
