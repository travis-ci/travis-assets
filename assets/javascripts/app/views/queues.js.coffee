@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Queues =
  Show: Ember.View.extend
    templateName: 'app/templates/queues/show'

