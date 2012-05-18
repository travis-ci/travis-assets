@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Branches =
  List: Ember.View.extend
    templateName: 'app/templates/branches/list'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    branchesBinding: 'controller.branches'

  Item: Ember.View.extend
    color: (->
      Travis.Helpers.colorForResult(this.getPath('content.result'))
    ).property('content.result')


