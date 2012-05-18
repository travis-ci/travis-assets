@Travis.Build = Travis.Model.extend Travis.Helpers,
  repository_id:   DS.attr('number')
  state:           DS.attr('string')
  number:          DS.attr('number')
  branch:          DS.attr('string')
  message:         DS.attr('string')
  result:          DS.attr('number')
  duration:        DS.attr('number')
  started_at:      DS.attr('string')
  finished_at:     DS.attr('string')
  committed_at:    DS.attr('string')
  committer_name:  DS.attr('string')
  committer_email: DS.attr('string')
  author_name:     DS.attr('string')
  author_email:    DS.attr('string')
  compare_url:     DS.attr('string')
  log:             DS.attr('string')

  repository: DS.belongsTo('Travis.Repository')
  commit:     DS.belongsTo('Travis.Commit')
  # jobs:       DS.hasMany('Travis.Job', key: 'job_ids')

  config: (->
    @getPath 'data.config'
  ).property('data.config')

  jobs: (->
    Travis.app.store.findMany(Travis.Job, @getPath('data.job_ids'))
  ).property('data.job_ids.length')

  requiredJobs: (->
    @get('jobs').filter (item, index) ->
      item.get('allow_failure') isnt true
  ).property('jobs')

  allowedFailureJobs: (->
    @get('jobs').filter (item, index) ->
      item.get 'allow_failure'
  ).property('jobs')

  hasFailureMatrix: (->
    @get('allowedFailureJobs').length > 0
  ).property('allowedFailureJobs')

  isMatrix: (->
    @getPath('jobs.length') > 1
  ).property('jobs.length')

  tick: ->
    @notifyPropertyChange 'duration'
    @notifyPropertyChange 'finished_at'

  url: (->
    '#!/' + @getPath('repository.slug') + '/builds/' + @get('id')
  ).property('repository.status', 'id')

  urlAuthor: (->
    'mailto:' + @get('author_email')
  ).property('author_email')

  urlCommitter: (->
    'mailto:' + @get('committer_email')
  ).property('committer_email')

  urlGithubCommit: (->
    'http://github.com/%@/commit/%@'.fmt @getPath('repository.slug'), @get('commit')
  ).property('repository.slug', 'commit')

@Travis.Build.reopenClass
  byRepositoryId: (id, parameters) ->
    @all($.extend(parameters || {}, repository_id: id, orderBy: 'number DESC'))

  olderThanNumber: (id, build_number) ->
    @all(url: '/repositories/' + id + '/builds.json?bare=true&after_number=' + build_number, repository_id: id, orderBy: 'number DESC')
