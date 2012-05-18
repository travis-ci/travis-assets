Travis.ServiceHooksController = Ember.ArrayController.extend
  init: ->
    @_super()
    view = Ember.View.create
      serviceHooks: @
      templateName: 'app/templates/service_hooks/list'
    view.appendTo('#service_hooks')
    @set('content', Travis.ServiceHook.all(orderBy: 'active DESC, name'))

  state: (->
    if @get('active') then 'on' else 'off'
  ).property('active')

  githubUrl: (->
    '%@/admin/hooks#travis_minibucket'.fmt @get('url')
  ).property('url')


