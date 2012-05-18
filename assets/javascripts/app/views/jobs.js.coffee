@Travis.Views = {} if @Travis.Views == undefined

@Travis.Views.Jobs =
  Show: Ember.View.extend
    templateName: 'app/templates/jobs/show'
    controllerBinding: 'Travis.app.main'
    jobBinding: 'controller.job'
    commitBinding: 'controller.job.commit'

    color: (->
      Travis.Helpers.colorForResult(this.getPath('job.result'))
    ).property('job.result')

  Log: Ember.View.extend
    templateName: 'app/templates/jobs/log'
    controllerBinding: 'Travis.app.main'
    jobBinding: 'controller.job'

    didInsertElement: ->
      @_super.apply(this, arguments)
      # TODO: FIXME: how/where to do this properly?
      Ember.run.later this, (->
        number = Travis.app.main.getPath('params.number')
        line = $(".log a[name='" + number + "']")
        if (number && line.length > 0)
          $(window).scrollTop(line.offset().top)
          line.addClass('highlight')
      ), 500

  List: Ember.View.extend
    templateName: 'app/templates/jobs/list'
    controllerBinding: 'Travis.app.main'
    buildBinding: 'controller.build'

    configKeys: (->
      config = @getPath('build.config')
      return [] unless config
      keys = $.keys($.only(config, 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'perl', 'python', 'scala'))
      headers = [I18n.t('build.job'), I18n.t('build.duration'), I18n.t('build.finished_at')]
      $.map(headers.concat(keys), (key) -> return $.camelize(key))
    ).property('build.config')

  Item: Ember.View.extend
    tagName: 'tbody'

    color: (->
      Travis.Helpers.colorForResult(this.getPath('content.result'))
    ).property('content.result')

    configValues: (->
      config = @getPath('content.config')
      return [] unless config
      values = $.values($.only(config, 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'scala', 'jdk', 'python', 'perl'))
      $.map(values, (value) -> Ember.Object.create(value: value))
    ).property('content.config')

