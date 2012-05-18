@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Builds =
  Show: Ember.View.extend
    templateName: 'app/templates/builds/show'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    buildBinding: 'controller.build'
    commitBinding: 'controller.build.commit'

    color: (->
      Travis.Helpers.colorForResult(this.getPath('build.result'))
    ).property('build.result')

  List: Ember.View.extend
    templateName: 'app/templates/builds/list'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    buildsBinding: 'controller.builds'

    showMore: ->
      Travis.app.main.showMore()

    hasMoreBinding: Em.Binding.oneWay('content.lastObject.number').transform (value) ->
      value && value > 1

  Item: Ember.View.extend
    color: (->
      Travis.Helpers.colorForResult(this.getPath('content.result'))
    ).property('content.result')


