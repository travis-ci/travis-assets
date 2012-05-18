@Travis.EventsController = Ember.Object.extend
  receive: (event, data) ->
    action = $.camelize(event.replace(':', '_'), false)
    @[action](data)

  jobCreated: (data) ->
    @load(data)

  jobStarted: (data) ->
    @load(data)

  jobLog: (data) ->
    job = Travis.Job.find(data.job.id)
    job.appendLog(data.job._log) if(job)

  jobFinished: (data) ->
    @load(data)

  buildStarted: (data) ->
    @load(data)

  buildFinished: (data) ->
    @load(data)

  workerAdded: (data) ->
    @load(data)

  workerCreated: (data) ->
    @load(data)

  workerUpdated: (data) ->
    @load(data)

  workerRemoved: (data) ->
    worker = Travis.Worker.find(data.worker.id)
    worker.destroy() if(worker)

  # private

  load: (data) ->
    for key of data
      if key[key.length - 1] == 's'
        @loadRecord(key.substr(0, key.length - 1), record) for record in data[key]
      else
        @loadRecord(key, data[key])

  loadRecord: (type, data) ->
    Travis[$.camelize(type)].load(data)
