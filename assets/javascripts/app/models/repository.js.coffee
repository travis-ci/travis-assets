@Travis.Repository = Travis.Model.extend Travis.Helpers,
  slug:                   DS.attr('string')
  name:                   DS.attr('string')
  owner:                  DS.attr('string')
  description:            DS.attr('string')
  last_build_id:          DS.attr('number')
  last_build_number:      DS.attr('string')
  last_build_result:      DS.attr('number')
  last_build_started_at:  DS.attr('string')
  last_build_finished_at: DS.attr('string')

  builds: (->
    Travis.Build.byRepositoryId @get('id'), event_type: 'push'
  ).property()

  pullRequests: (->
    Travis.Build.byRepositoryId @get('id'), event_type: 'pull_request'
  ).property()

  lastBuild: (->
    Travis.Build.find @get('last_build_id')
  ).property('last_build_id')

  last_build_duration: (->
    duration = @getPath('data.last_build_duration')
    duration = @durationFrom(@get('last_build_started_at'), @get('last_build_finished_at')) unless duration
    duration
  ).property('last_build_duration', 'last_build_started_at', 'last_build_finished_at')

  stats: (->
    return unless Travis.env is 'production'
    url = 'https://api.github.com/json/repos/show/' + @get('slug')
    @get('_stats') || $.get(url, (data) => @set('_stats', data)) && undefined
  ).property('_stats')

  select: ->
    Travis.Repository.select(self.get('id'))

  tick: ->
    @notifyPropertyChange 'last_build_duration'
    @notifyPropertyChange 'last_build_finished_at'

  urlCurrent: (->
    '#!/' + @getPath('slug')
  ).property('slug')

  urlBuilds: (->
    '#!/' + @get('slug') + '/builds'
  ).property('slug')

  urlBranches: (->
    '#!/' + @get('slug') + '/branches'
  ).property('slug')

  urlPullRequests: (->
    '#!/' + @get('slug') + '/pull_requests'
  ).property('slug')

  urlLastBuild: (->
    '#!/' + @get('slug') + '/builds/' + @get('last_build_id')
  ).property('last_build_id')

  urlGithub: (->
    'http://github.com/' + @get('slug')
  ).property('slug')

  urlGithubWatchers: (->
    'http://github.com/' + @get('slug') + '/watchers'
  ).property('slug')

  urlGithubNetwork: (->
    'http://github.com/' + @get('slug') + '/network'
  ).property('slug')

  urlGithubAdmin: (->
    @get('url') + '/admin/hooks#travis_minibucket'
  ).property('slug')

  urlStatusImage: (->
    @get('slug') + '.png'
  ).property('slug')

@Travis.Repository.reopenClass
  recent: ->
    @all() # (orderBy: 'last_build_started_at DESC')

  ownedBy: (owner_name) ->
    @all(owner_name: owner_name, orderBy: 'name')

  search: (query) ->
    @all(search: query, orderBy: 'name')

  bySlug: (slug) ->
    repo = $.detect(@all().toArray(), (repo) -> repo.get('slug') == slug)
    if repo then Ember.ArrayProxy.create(content: [repo]) else @all(slug: slug)

  select: (id) ->
    @all().forEach (repository) ->
      repository.set 'selected', repository.get('id') is id
