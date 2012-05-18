@Travis.Job = Travis.Model.extend Travis.Helpers,
  repository_id:   DS.attr('number')
  build_id:        DS.attr('number')
  state:           DS.attr('string')
  number:          DS.attr('string')
  result:          DS.attr('number')
  started_at:      DS.attr('string')
  finished_at:     DS.attr('string')
  allow_failure:   DS.attr('boolean')

  repository: DS.belongsTo('Travis.Repository')
  commit: DS.belongsTo('Travis.Commit')

  config: (->
    @getPath 'data.config'
  ).property('data.config')

  log: (->
    @subscribe()
    log = @getPath('data.log')
    @refresh()  if log is undefined
    log || ''
  ).property('data.log')

  duration: (->
    @durationFrom @get('started_at'), @get('finished_at')
  ).property('started_at', 'finished_at')

  appendLog: (log) ->
    @set 'log', @get('log') + log

  subscribe: ->
    Travis.app.subscribe 'job-' + @get('id')

  onStateChange: (->
    Travis.app.unsubscribe 'job-' + @get('id') if @get('state') == 'finished'
  ).observes('state')

  tick: ->
    @notifyPropertyChange 'duration'
    @notifyPropertyChange 'finished_at'

  url: (->
    '#!/%@/jobs/%@'.fmt @getPath('repository.slug'), @get('id')
  ).property('repository', 'id')

@Travis.Job.reopenClass
  queued: (queue) ->
    @all(state: 'created', queue: 'builds.' + queue)
