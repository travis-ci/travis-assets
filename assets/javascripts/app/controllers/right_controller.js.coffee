@Travis.RightController = Ember.Object.extend
  cookie: 'sidebar_minimized'
  queues: [
    { name: 'common',  display: 'Common' },
    { name: 'php',     display: 'PHP, Perl and Python' },
    { name: 'node_js', display: 'Node.js' },
    { name: 'jvmotp',  display: 'JVM and Erlang' },
    { name: 'rails',   display: 'Rails' },
    { name: 'spree',   display: 'Spree' },
  ]

  init: ->
    @_super()

    Travis.WorkersController.create()
    $(@queues).each (ix, queue) ->
      Travis.QueueController.create(queue)

    @minimize() if $.cookie(@cookie) == 'true'
    @persist()

  toggle: ->
    if @isMinimized() then @maximize() else @minimize()
    @persist()

  isMinimized: ->
    $('#right').hasClass('minimized')

  minimize: ->
    $('#right').addClass('minimized')
    $('#main').addClass('maximized')

  maximize: ->
    $('#right').removeClass('minimized')
    $('#main').removeClass('maximized')

  persist: ->
    $.cookie(@cookie, @isMinimized())

