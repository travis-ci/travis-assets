@Travis.LeftController = Ember.ArrayController.extend
  init: ->
    @_super()
    @tabs = Travis.LeftStates.create()
    @set 'searchBox', Travis.app.layout.left.searchBox
    @ticker = Travis.Ticker.create(context: this, targets: ['content'])

  activate: (tab, params) ->
    @set('content', @[tab]())
    @tabs.activate(tab)

  recent: ->
    Travis.Repository.recent()

  mine: ->
    Travis.Repository.ownedBy(name)

  search: ->
    Travis.Repository.search(@query())

  query: ->
    @getPath('searchBox.value')

  searchObserver: (->
    @activate(if @query() then 'search' else 'recent')
  ).observes('searchBox.value')

  # TODO why does this not work and what's a better way to sort a RecordArray?
  sorting: (content) ->
    # controller = @
    # content.addObserver '@each.last_build_started_at', ->
    #   records = []
    #   content.forEach (record) -> records.push(record)
    #   sorted = records.sort (a, b) ->
    #     if a.get('last_build_started_at') > b.get('last_build_started_at') then -1 else 1
    #   ids = (record.get('id') for record in sorted)

    #   controller.propertyWillChange('content')
    #   content.get('content').splice.apply([0, sorted.length].concat(ids))
    #   controller.propertyDidChange('content')
    content
