@Travis = Ember.Namespace.create() if @Travis == undefined

@Travis.State = Ember.ViewState.extend
  enter: (stateManager, transition) ->
    @_super(stateManager, transition)
    Ember.run.next =>
      $('.tabs li').removeClass('active')
      $('#tab_' + @get('name')).addClass('active')


