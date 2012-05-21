@Travis.AppController = Ember.Application.extend
  TICK_INTERVAL: 1000

  channels: ['common']
  channel_prefix: ''
  active_channels: []

  init: ->
    @_super()
    @initStore()

  run: ->
    @action()
    @initEvents()
    @initPusher()

  home: ->
    @layout = Travis.Views.Layouts.Default.create()
    @layout.appendTo('body')

    Ember.run.next =>
      @set 'left',   Travis.LeftController.create()
      @set 'main',   Travis.MainController.create()
      @set 'right',  Travis.RightController.create()
      @set 'events', Travis.EventsController.create()

  action: ->
    action = $('body').attr('id')
    @[action]() if(@[action])

  initStore: ->
    @store = DS.Store.create
      revision: 4
      adapter: Travis.DataStoreAdapter.create(bulkCommit: false)

  profile: ->
    Travis.ServiceHooksController.create()

  receive: (event, data) ->
    Travis.app.events.receive(event, data)

  subscribe: (channel) ->
    if @active_channels.indexOf(channel) == -1
      @active_channels.push(channel)
      pusher.subscribe(@channel_prefix + channel).bind_all(@receive) if window.pusher

  unsubscribe: (channel) ->
    ix = @active_channels.indexOf(channel)
    if ix == -1
      @active_channels.splice(ix, 1)
      pusher.unsubscribe(@channel_prefix + channel) if window.pusher

  unsubscribeAll: (pattern) ->
    $(@active_channels).each (ix, channel) =>
      @unsubscribe(channel) if channel.match(pattern)

  initPusher: ->
    $.each(Travis.app.channels, (ix, channel) => @subscribe(channel)) if window.pusher

  initEvents: ->
    $('.tool-tip').tipsy(gravity: 'n', fade: true)
    $('.fold').live 'click', -> $(this).toggleClass('open')

    $('#top .profile').mouseover -> $('#top .profile ul').show()
    $('#top .profile').mouseout  -> $('#top .profile ul').hide()

    $('.repository').live 'mouseover', -> $(this).find('.description').show()
    $('.repository').live 'mouseout',  -> $(this).find('.description').hide()

  # startLoading: ->
  #   $("#main").addClass("loading")

  # stopLoading: ->
  #   $("#main").removeClass("loading")


