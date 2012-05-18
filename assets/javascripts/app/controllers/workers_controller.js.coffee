@Travis.WorkersController = Ember.ArrayController.extend
  init: ->
    @_super()
    @set 'workers', Travis.Worker.all(orderBy: 'host')
    @createView()

  createView: ->
    view = Travis.Views.Workers.List.create(groups: this)
    Travis.app.layout.right.workers.get('childViews').pushObject(view)

  workersObserver: (->
    groups = {}
    workers = @get('workers') || []

    workers.forEach (worker) =>
      host = worker.get('host')
      groups[host] = Travis.WorkerGroup.create() if(!(host in groups))
      groups[host].add(worker)

    @set 'content', $.values(groups)
  ).observes('workers.length')

