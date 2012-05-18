@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Repositories =
  Show: Ember.View.extend
    templateName: 'app/templates/repositories/show'
    controllerBinding: 'Travis.app.main'
    repositoryBinding: 'controller.repository'
    buildBinding: 'controller.build'
    jobBinding: 'controller.job'

  List: Ember.View.extend
    templateName: 'app/templates/repositories/list'
    controllerBinding: 'Travis.app.left'
    repositoriesBinding: 'controller'

  Item: Ember.View.extend
    color: (->
      Travis.Helpers.colorForResult(@getPath('content.last_build_result'))
    ).property('content.last_build_result')

    class: (->
      classes = ['repository', @get('color')]
      classes.push 'selected' if @getPath('content.selected')
      classes.join(' ')
    ).property('content.last_build_result', 'content.selected')

  Tab: Ember.CollectionView

  Tools: Ember.View.extend
    templateName: 'app/templates/repositories/tools'
    selector: '#repository .tools'

    toggle: ->
      $(this.selector + ' .content').toggle()

    update: ->
      @set 'branch', $(this.selector + ' select').val()

    repositoryUrl: (->
      'http://travis-ci.org/%@'.fmt(@getPath('repository.slug'))
    ).property('repository.slug')

    imageUrl: (->
      branch = @get('branch')
      path = 'https://secure.travis-ci.org/%@.png'.fmt(@getPath('repository.slug'))
      if branch then path + '?branch=' + branch else path
    ).property('repository.slug', 'branch')

    markdown: (->
      '[![Build Status](%@)](%@)'.fmt(@get('imageUrl'), @get('repositoryUrl'))
    ).property('imageUrl')

    textile: (->
      '!%@(Build Status)!:%@'.fmt(@get('imageUrl'), @get('repositoryUrl'))
    ).property('imageUrl')

    rdoc: (->
      '{<img src="%@" alt="Build Status" />}[%@]'.fmt(@get('imageUrl'), @get('repositoryUrl'))
    ).property('imageUrl')

