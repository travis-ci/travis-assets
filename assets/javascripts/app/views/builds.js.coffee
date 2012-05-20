@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Builds =
  List: Ember.View.extend
    templateName: 'app/templates/builds/list'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    buildsBinding: 'controller.builds'

    showMore: ->
      Travis.app.main.showMore()

    hasMoreBinding: Em.Binding.oneWay('content.lastObject.number').transform (value) ->
      value && value > 1

  Item: Ember.View.extend
    color: (->
      Travis.Helpers.colorForResult(this.getPath('content.result'))
    ).property('content.result')

    urlBuild: (->
      build = @get('content')
      Travis.Urls.build(build.get('repository'), build) if build
    ).property('content')

    urlGithubCommit: (->
      build = @get('content')
      Travis.Urls.githubCommit(build.get('repository'), build.get('commit')) if build
    ).property('content')

  Show: Ember.View.extend
    templateName: 'app/templates/builds/show'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    buildBinding: 'controller.build'
    commitBinding: 'controller.build.commit'
    jobBinding: 'controller.job'

    color: (->
      Travis.Helpers.colorForResult(this.getPath('build.result'))
    ).property('build.result')

    urlBuild: (->
      repo = @get('repository')
      build = @get('build')
      Travis.Urls.build(repo, build) if repo && build
    ).property('repository', 'build.id')

    urlGithubCommit: (->
      repo = @get('repository')
      commit = @get('commit')
      Travis.Urls.githubCommit(repo, commit) if repo && commit
    ).property('repository', 'commit')

    urlAuthor: (->
      commit = @get('commit')
      Travis.Urls.author(commit) if commit
    ).property('commit')

    urlCommitter: (->
      commit = @get('commit')
      Travis.Urls.committer(commit) if commit
    ).property('commit')
