@Travis.QueueController = Ember.ArrayController.extend
  init: ->
    @_super()
    @set 'content', Travis.Job.queued(@get('name'))
    @createView()

  createView: ->
    view = Travis.Views.Queues.Show.create
      name: @get('name')
      display: @get('display')
      jobs: this
    Travis.app.layout.right.queues.get('childViews').pushObject(view)


