@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Layouts =
  Default: Ember.View.extend
    templateName: 'app/templates/layouts/default'

  Main: Ember.View.extend
    templateName: 'app/templates/layouts/_main'

  Left: Ember.View.extend
    templateName: 'app/templates/layouts/_left'
    click: (event)->
      # TODO this is being triggered twice?
      # TODO this is being triggered when the searchbox is clicked? wtf.
      id = $(event.srcElement).closest('.tabs li').attr('id')
      Travis.app.left.activate(id.replace('tab_', '')) if id

  Right: Ember.View.extend
    templateName: 'app/templates/layouts/_right'
    toggle: ->
      Travis.app.right.toggle()

