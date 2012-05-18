@Travis.LeftStates = Em.StateManager.extend
  activate: (state, params) ->
    @rootView = Travis.app.layout.left.tab
    @goToState(state)

  recent: Travis.State.create
    name: 'recent'
    view: Travis.Views.Repositories.List

  my_repositories: Travis.State.create
    name: 'my_repositories'
    view: Travis.Views.Repositories.List

  search: Travis.State.create
    name: 'search'
    view: Travis.Views.Repositories.List
