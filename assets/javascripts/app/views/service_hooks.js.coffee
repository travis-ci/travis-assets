@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.ServiceHooks =
  Item: Ember.View.extend
    urlGithubAdmin: (->
      repo = @get('content') # the hook quacks like a repo by responding to :slug
      Travis.Urls.githubAdmin(repo) if repo
    ).property('repository')
