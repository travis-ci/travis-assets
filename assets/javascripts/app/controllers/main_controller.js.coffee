@Travis.MainController = Ember.Object.extend
  repositoryBinding: '_repositories.firstObject'
  buildsBinding: '_builds.content'
  buildBinding: '_build.content'
  branchesBinding: 'repository.branches'

  init: ->
    @_super()
    @tabs = Travis.MainStates.create()
    @ticker = Travis.Ticker.create(context: this, targets: ['builds', 'build', 'branches'])
    Ember.run.next => @initRoutes()

  initRoutes: ->
    Ember.routes.add '!/:owner/:name/jobs/:id/:number', (params) => @activate('job', params)
    Ember.routes.add '!/:owner/:name/jobs/:id',         (params) => @activate('job', params)
    Ember.routes.add '!/:owner/:name/builds/:id',       (params) => @activate('build', params)
    Ember.routes.add '!/:owner/:name/builds',           (params) => @activate('history', params)
    Ember.routes.add '!/:owner/:name/pull_requests',    (params) => @activate('pull_requests', params)
    Ember.routes.add '!/:owner/:name/branches',         (params) => @activate('branches', params)
    Ember.routes.add '!/:owner/:name',                  (params) => @activate('current', params)
    Ember.routes.add '',                                (params) => @activate('current')

  activate: (tab, params) ->
    @set('params', params)
    @set('tab', tab)
    @tabs.activate(tab)

  job: (->
    tab = @get('tab')
    id = if tab == 'job'
      @get('params').id
    else if tab == 'current' or tab == 'build'
      @getPath('build.data.job_ids.firstObject')
    Travis.Job.find(id) if id
  ).property('tab', 'build.data.job_ids.length')

  _slug: (->
    parts = $.compact([@getPath('params.owner'), @getPath('params.name')])
    parts.join('/') if parts.length > 0
  ).property('params')

  _repositories: (->
    slug = @get('_slug')
    if slug then Travis.Repository.bySlug(slug) else Travis.Repository.recent()
  ).property('_slug')

  _build: (->
    tab = @get('tab')
    if tab == 'current'
      Ember.Object.create(parent: @, contentBinding: 'parent.repository.lastBuild')
    else if tab == 'build'
      Ember.Object.create(parent: @, content: Travis.Build.find(@getPath('params.id')))
    else if tab == 'job'
      Ember.Object.create(parent: @, contentBinding: 'parent.job.build')
  ).property('tab')

  _builds: (->
    tab = @get('tab')
    if tab == 'history'
      Ember.Object.create(parent: @, contentBinding: 'parent.repository.builds')
    else if tab == 'builds'
      Ember.Object.create(parent: @, contentBinding: 'parent.repository.pull_requests')
  ).property('tab')

  # TODO this doesn't work ...
  showMore: ->
    repositoryId = @getPath('repository.id')
    number = @getPath('builds.lastObject.number')
    builds = @get('builds')
    builds.contentWillChange()
    Travis.Build.olderThanNumber(repositoryId, number).forEach (build) ->
      builds.addObject(build)
    builds.contentDidChange()
