@Travis.MainStates = Em.StateManager.extend
  activate: (state, params) ->
    @rootView = Travis.app.layout.main.tab
    @goToState(state)

  current: Travis.State.create
    name: 'current'
    view: Travis.Views.Builds.Show

  history: Travis.State.create
    name: 'history'
    view: Travis.Views.Builds.List

  pull_requests: Travis.State.create
    name: 'pull_requests'
    view: Travis.Views.Builds.List

  branches: Travis.State.create
    name: 'branches'
    view: Travis.Views.Branches.List

  build: Travis.State.create
    name: 'build'
    view: Travis.Views.Builds.Show

  job: Travis.State.create
    name: 'job'
    view: Travis.Views.Jobs.Show
