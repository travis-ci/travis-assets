@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Workers =
  List: Ember.View.extend
    templateName: 'app/templates/workers/list'

