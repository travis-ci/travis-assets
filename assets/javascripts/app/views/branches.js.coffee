@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Branches =
  List: Ember.View.extend
    templateName: 'app/templates/branches/list'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'

    branches: (->
      Travis.Branch.byRepositoryId @getPath('repository.id')
    ).property('repository.id')

  Item: Ember.View.extend
    repository: (->
      @getPath('content.repository')
    ).property('content.repository')

    color: (->
      Travis.Helpers.colorForResult(@getPath('content.result'))
    ).property('content.result')

    urlBuild: (->
      repo = @get('repository')
      build = @get('content')
      Travis.Urls.build(repo, build) if repo && build
    ).property('repository', 'content')

    urlGithubCommit: (->
      repo = @get('repository')
      build = @get('content')
      Travis.Urls.githubCommit(repo, build.get('commit')) if repo && build
    ).property('repository', 'content')


