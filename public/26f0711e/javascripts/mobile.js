Travis.Helpers.Common = {
  colorForResult: function(result) {
    return result == 0 ? 'green' : result == 1 ? 'red' : null;
  },

  timeAgoInWords: function(date) {
    return $.timeago.distanceInWords(date);
  },

  durationFrom: function(started, finished) {
    started  = started  && this._toUtc(new Date(this._normalizeDateString(started)));
    finished = finished ? this._toUtc(new Date(this._normalizeDateString(finished))) : this._nowUtc();
    return started && finished ? Math.round((finished - started) / 1000) : 0;
  },

  readableTime: function(duration) {
    var days    = Math.floor(duration / 86400);
    var hours   = Math.floor(duration % 86400 / 3600);
    var minutes = Math.floor(duration % 3600 / 60);
    var seconds = duration % 60;

    if(days > 0) {
      return 'more than 24 hrs';
    } else {
      var result = [];
      if(hours  == 1) { result.push(hours + ' hr'); }
      if(hours   > 1) { result.push(hours + ' hrs'); }
      if(minutes > 0) { result.push(minutes + ' min'); }
      if(seconds > 0) { result.push(seconds + ' sec'); }
      return result.length > 0 ? result.join(' ') : '-';
    }
  },

  _normalizeDateString: function(string) {
    if(window.JHW) {
      // TODO i'm not sure why we need to do this. in the chrome console the
      // Date constructor would take a string like "2011-09-02T15:53:20.927Z"
      // whereas in unit tests this returns an "invalid date". wtf ...
      string = string.replace('T', ' ').replace(/-/g, '/');
      string = string.replace('Z', '').replace(/\..*$/, '');
    }
    return string;
  },

  _nowUtc: function() {
    return this._toUtc(new Date());
  },

  _toUtc: function(date) {
    return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds());
  },

  emojize: function(text) {
    var emojis = text.match(/:\S+?:/g);
    if (emojis !== null){
      $.each(emojis.uniq(), function(ix, emoji) {
        var strippedEmoji = emoji.substring(1, emoji.length - 1);
        if (Travis.Helpers.EmojiDictionary.indexOf(strippedEmoji) != -1) {
          var image = '<img class="emoji" title="' + emoji + '" alt="' + emoji + '" src="/assets/emoji/' + strippedEmoji + '.png"/>';
          text = text.replace(new RegExp(emoji, 'g'), image);
        }
      });
    }
    return text;
  },

  escape: function(text) {
    return text
              .replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;');
  },
  // extracted from build and job models

  _formattedMessage: function() {
    return this.emojize(this.escape(this.get('message') || '')).replace(/\n/g,'<br/>');
  },

  _formattedDuration: function() {
    var duration = this.get('duration');
    if(!duration) duration = this.durationFrom(this.get('started_at'), this.get('finished_at'));
    return this.readableTime(duration);
  },

  _formattedFinishedAt: function() {
    return this.timeAgoInWords(this.get('finished_at')) || '-';
  },

  _formattedCompareUrl: function() {
    var parts = (this.get('compare_url') || '').split('/');
    return parts[parts.length - 1];
  },

  _formattedCommit: function(record) {
    var branch = this.get('branch');
    return (this.get('commit') || '').substr(0, 7) + (branch ? ' (%@)'.fmt(branch) : '');
  },

  _formattedConfig: function() {
    var config = $.only(this.get('config'), 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'scala', 'jdk', 'python', 'perl');
    var values = $.map(config, function(value, key) {
      value = (value && value.join) ? value.join(', ') : (value || '');
      return '%@: %@'.fmt($.camelize(key), value);
    });
    return values.length == 0 ? '-' : values.join(', ');
  }

};
Handlebars.registerHelper('whats_this', function(id) {
    return new Handlebars.SafeString('<span title="What\'s This?" class="whats_this" onclick="$.facebox({ div: \'#'+id+'\'})">&nbsp;</span>');
});
Handlebars.registerHelper('tipsy', function(text, tip) {
  return new Handlebars.SafeString('<span class="tool-tip" original-title="'+tip+'">'+text+'</span>');
});
Handlebars.registerHelper('i18n', function(key) {
  return new Handlebars.SafeString(I18n.t(key))
});
Travis.Branch = Travis.Record.extend(Travis.Helpers.Common, {
  repository: function() {
    if(this.get('repository_id')) return Travis.Repository.find(this.get('repository_id'));
  }.property('repository_id').cacheable(),

  color: function() {
    return Travis.Helpers.Common.colorForResult(this.get('result'));
  }.property(),

  buildUrl: function() {
    return '#!/' + this.getPath('repository.slug') + '/builds/' + this.get('build_id');
  }.property(),

  commitUrl: function() {
    return 'http://github.com/' + this.getPath('repository.slug') + '/commit/' + this.get('commit');
  }.property(),

  formattedCommit: function() {
    return this.get('commit').substr(0,7);
  }.property(),

  formattedStartedAt: function() {
    return Travis.Helpers.Common.timeAgoInWords(this.get('started_at'));
  }.property(),

  formattedFinishedAt: function() {
    return Travis.Helpers.Common.timeAgoInWords(this.get('finished_at'));
  }.property(),
});

Travis.Branch.reopenClass({
  resource: 'branches',

  summary: function(repository) {
    return this.all({ repository_id: repository.get('id') });
  }
});
Travis.Build = Travis.Record.extend(Travis.Helpers.Common, {
  repository_id:   Ember.Record.attr(Number),
  config:          Ember.Record.attr(Object),
  state:           Ember.Record.attr(String),
  number:          Ember.Record.attr(Number),
  commit:          Ember.Record.attr(String),
  branch:          Ember.Record.attr(String),
  message:         Ember.Record.attr(String),
  result:          Ember.Record.attr(Number),
  duration:        Ember.Record.attr(Number),
  started_at:      Ember.Record.attr(String), // use DateTime?
  finished_at:     Ember.Record.attr(String),
  committed_at:    Ember.Record.attr(String),
  committer_name:  Ember.Record.attr(String),
  committer_email: Ember.Record.attr(String),
  author_name:     Ember.Record.attr(String),
  author_email:    Ember.Record.attr(String),
  compare_url:     Ember.Record.attr(String),
  log:             Ember.Record.attr(String),

  matrix: Ember.Record.toMany('Travis.Job', { nested: true }),

  update: function(attrs) {
    if('matrix' in attrs) attrs.matrix = this._joinMatrixAttributes(attrs.matrix);
    this._super(attrs);
  },

  updateTimes: function() {
    this.notifyPropertyChange('duration');
    this.notifyPropertyChange('finished_at');
  },

  // We need to join given attributes with existing attributes because Ember.Record.toMany
  // does not seem to allow partial updates, i.e. would remove existing attributes?
  _joinMatrixAttributes: function(attrs) {
    var _this = this;
    return $.each(attrs, function(ix, job) {
      var _job = _this.get('matrix').objectAt(ix);
      if(_job) attrs[ix] = $.extend(_job.get('attributes') || {}, job);
    });
  },

  required_matrix: function() {
      return this.get('matrix').filter(function(item, index, self) { return item.get('allow_failure') != true });
  }.property('matrix').cacheable(),

  allow_failure_matrix: function() {
      return this.get('matrix').filter(function(item, index, self) { return item.get('allow_failure') });
  }.property('matrix').cacheable(),

  repository: function() {
    if(this.get('repository_id')) return Travis.Repository.find(this.get('repository_id'));
  }.property('repository_id').cacheable(),

  hasFailureMatrix: function() {
      return this.get('allow_failure_matrix').length > 0;
  }.property('hasFailureMatrix').cacheable(),

  isMatrix: function() {
    return this.getPath('matrix.length') > 1;
  }.property('matrix.length').cacheable(),

  color: function() {
    return this.colorForResult(this.get('result'));
  }.property('result').cacheable(),

  // VIEW HELPERS

  formattedDuration: function() {
    return this._formattedDuration()
  }.property('duration', 'started_at', 'finished_at'),

  formattedFinishedAt: function() {
    return this._formattedFinishedAt();
  }.property('finished_at').cacheable(),

  formattedCommit: function() {
    return this._formattedCommit()
  }.property('commit', 'branch').cacheable(),

  formattedCompareUrl: function() {
    return this._formattedCompareUrl();
  }.property('compare_url').cacheable(),

  formattedConfig: function() {
    return this._formattedConfig();
  }.property('config').cacheable(),

  formattedMatrixHeaders: function() {
    var keys = $.keys($.only(this.get('config'), 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'perl', 'python', 'scala'));
    return $.map([I18n.t("build.job"), I18n.t("build.duration"), I18n.t("build.finished_at")].concat(keys), function(key) { return $.camelize(key) });
  }.property('config').cacheable(),

  formattedMessage: function(){
    return this._formattedMessage();
  }.property('message'),

  shortMessage: function(){
    return this.emojize(this.escape((this.get('message') || '').split(/\n/)[0]));
  }.property('message'),

  url: function() {
    return '#!/' + this.getPath('repository.slug') + '/builds/' + this.get('id');
  }.property('repository.status', 'id'),

  urlAuthor: function() {
    return 'mailto:' + this.get('author_email');
  }.property('author_email').cacheable(),

  urlCommitter: function() {
    return 'mailto:' + this.get('committer_email');
  }.property('committer_email').cacheable(),

  urlGithubCommit: function() {
    return 'http://github.com/' + this.getPath('repository.slug') + '/commit/' + this.get('commit');
  }.property('repository.slug', 'commit').cacheable()
});

Travis.Build.reopenClass({
  resource: 'builds',

  pushesByRepositoryId: function(id, parameters) {
    return this.all({ url: '/repositories/%@/builds.json?bare=true'.fmt(id), repository_id: id, orderBy: 'number DESC', event_type: 'push' });
  },

  pullRequestsByRepositoryId: function(id, parameters) {
    return this.all({ url: '/repositories/%@/builds.json?bare=true&event_type=pull_requests'.fmt(id), repository_id: id, orderBy: 'number DESC', event_type: 'pull_request' });
  },

  olderThanNumber: function(id, build_number) {
    return this.all({ url: '/repositories/' + id + '/builds.json?bare=true&after_number=' + build_number, repository_id: id, orderBy: 'number DESC' });
  }
});
Travis.Job = Travis.Record.extend(Travis.Helpers.Common, {
  repository_id:   Ember.Record.attr(Number),
  build_id:        Ember.Record.attr(Number),
  config:          Ember.Record.attr(Object),
  state:           Ember.Record.attr(String),
  number:          Ember.Record.attr(String),
  commit:          Ember.Record.attr(String),
  branch:          Ember.Record.attr(String),
  message:         Ember.Record.attr(String),
  result:          Ember.Record.attr(Number),
  started_at:      Ember.Record.attr(String), // use DateTime?
  finished_at:     Ember.Record.attr(String),
  committed_at:    Ember.Record.attr(String),
  committer_name:  Ember.Record.attr(String),
  committer_email: Ember.Record.attr(String),
  author_name:     Ember.Record.attr(String),
  author_email:    Ember.Record.attr(String),
  compare_url:     Ember.Record.attr(String),
  log:             Ember.Record.attr(String),
  allow_failure:   Ember.Record.attr(Boolean),

  build: function() {
    if(window.__DEBUG__) console.log('updating build on job ' + this.get('id'));
    return Travis.Build.find(this.get('build_id'));
  }.property('build_id').cacheable(),

  update: function(attrs) {
    var build = this.get('build');
    if(build) build.whenReady(function(build) {
      var job = build.get('matrix').find(function(a) { return a.get('id') == this.get('id') });
      if(job) { job.update(attrs); }
    });
    this._super(attrs);
  },

  subscribe: function() {
    var id = this.get('id');
    if(id && !this._subscribed) {
      this._subscribed = true;
      Travis.subscribe('job-' + id);
    }
  },

  appendLog: function(log) {
    this.set('log', this.get('log') + log);
  },

  unsubscribe: function() {
    this._subscribed = false;
    //randym: facinating, but possibly incorrect....
    //Travis.subscribe('job-' + this.get('id'));
    Travis.unsubscribe('job-' + this.get('id'));
  },

  formattedCompareUrl: function() {
    return this._formattedCompareUrl(this)
  }.property('compare_url').cacheable(),

  repository: function() {
    return Travis.Repository.find(this.get('repository_id'));
  }.property('repository_id').cacheable(),

  updateTimes: function() {
    this.notifyPropertyChange('duration');
    this.notifyPropertyChange('finished_at');
  },

  color: function() {
    return this.colorForResult(this.get('result'));
  }.property('result').cacheable(),

  duration: function() {
    return this.durationFrom(this.get('started_at'), this.get('finished_at'));
  }.property('finished_at'),

  // VIEW HELPERS

  formattedDuration: function() {
    return this._formattedDuration();
  }.property('duration'),

  formattedFinishedAt: function() {
    return this._formattedFinishedAt();
  }.property('finished_at').cacheable(),

  formattedCommit: function() {
    return this._formattedCommit()
  }.property('commit', 'branch').cacheable(),

  formattedCompareUrl: function() {
    return this._formattedCompareUrl();
  }.property('compare_url').cacheable(),

  formattedConfig: function() {
    return this._formattedConfig();
  }.property('config').cacheable(),

  formattedConfigValues: function() {
    var values = $.values($.only(this.getPath('config'), 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'scala', 'jdk', 'python', 'perl'));
    return $.map(values, function(value) {
      return Ember.Object.create({ value: value })
    });
  }.property().cacheable(),

  formattedLog: function() {
    var log = this.getPath('log');
    return log ? Travis.Log.filter(log) : '';
  }.property('log').cacheable(),

  formattedMessage: function(){
    return this._formattedMessage();
  }.property('message'),

  url: function() {
    return '#!/' + this.getPath('repository.slug') + '/jobs/' + this.get('id');
  }.property('repository', 'id'),
});

Travis.Job.reopenClass({
  resource: 'jobs'
});

Travis.Repository = Travis.Record.extend(Travis.Helpers.Common, {
  slug:                   Ember.Record.attr(String),
  name:                   Ember.Record.attr(String),
  owner:                  Ember.Record.attr(String),
  description:            Ember.Record.attr(String),
  last_build_id:          Ember.Record.attr(Number),
  last_build_number:      Ember.Record.attr(String),
  last_build_result:      Ember.Record.attr(Number),
  last_build_duration:    Ember.Record.attr(Number),
  last_build_started_at:  Ember.Record.attr(String),  // DateTime doesn't seem to work?
  last_build_finished_at: Ember.Record.attr(String),

  select: function() {
    this.whenReady(function(self) {
      Travis.Repository.select(self.get('id'))
    });
  },

  updateTimes: function() {
    this.notifyPropertyChange('last_build_duration');
    this.notifyPropertyChange('last_build_finished_at');
  },

  branchSummary: function() {
    return Travis.Branch.summary(this);
  }.property(),

  builds: function() {
    return Travis.Build.pushesByRepositoryId(this.get('id'));
  }.property().cacheable(),

  pull_requests: function() {
    return Travis.Build.pullRequestsByRepositoryId(this.get('id'));
  }.property().cacheable(),

  lastBuild: function() {
    return Travis.Build.find(this.get('last_build_id'));
  }.property('last_build_id'),

  // VIEW HELPERS

  color: function() {
    return this.colorForResult(this.get('last_build_result'));
  }.property('last_build_result').cacheable(),

  formattedLastBuildDuration: function() {
    var duration = this.get('last_build_duration');
    if(!duration) duration = this.durationFrom(this.get('last_build_started_at'), this.get('last_build_finished_at'));
    return this.readableTime(duration);
  }.property('last_build_duration', 'last_build_started_at', 'last_build_finished_at'),

  formattedLastBuildFinishedAt: function() {
    return this.timeAgoInWords(this.get('last_build_finished_at')) || '-';
  }.property('last_build_finished_at'),

  cssClasses: function() { // ugh
    return $.compact(['repository', this.get('color'), this.get('selected') ? 'selected' : null]).join(' ');
  }.property('color', 'selected').cacheable(),

  urlCurrent: function() {
    return '#!/' + this.getPath('slug');
  }.property('slug').cacheable(),

  urlBuilds: function() {
    return '#!/' + this.get('slug') + '/builds';
  }.property('slug').cacheable(),

  urlLastBuild: function() {
    return '#!/' + this.get('slug') + '/builds/' + this.get('last_build_id');
  }.property('last_build_id').cacheable(),

  urlGithub: function() {
    return 'http://github.com/' + this.get('slug');
  }.property('slug').cacheable(),

  urlGithubWatchers: function() {
    return 'http://github.com/' + this.get('slug') + '/watchers';
  }.property('slug').cacheable(),

  urlGithubNetwork: function() {
    return 'http://github.com/' + this.get('slug') + '/network';
  }.property('slug').cacheable(),

  urlGithubAdmin: function() {
    return this.get('url') + '/admin/hooks#travis_minibucket';
  }.property('slug').cacheable(),

  urlBranches: function() {
    return '#!/' + this.get('slug') + '/branch_summary';
  }.property('slug').cacheable(),

  urlPullRequests: function() {
    return '#!/' + this.get('slug') + '/pull_requests';
  }.property('slug').cacheable(),

  urlStatusImage: function() {
    return this.get('slug') + '.png'
  }.property('slug').cacheable()

});

Travis.Repository.reopenClass({
  resource: 'repositories',

  recent: function() {
    return this.all({ orderBy: 'last_build_started_at DESC' });
  },

  owned_by: function(githubId) {
    return Travis.store.find(Ember.Query.remote(Travis.Repository, { url: 'repositories.json?owner_name=' + githubId, orderBy: 'name' }));
  },

  search: function(search) {
    return Travis.store.find(Ember.Query.remote(Travis.Repository, { url: 'repositories.json?search=' + search, orderBy: 'name' }));
  },

  bySlug: function(slug) {
    return this.all({ slug: slug });
  },

  select: function(id) {
    this.all().forEach(function(repository) {
      repository.whenReady(function() {
        repository.set('selected', repository.get('id') == id);
      });
    });
  }
});
Travis.ServiceHook = Travis.Record.extend({
  primaryKey: 'uid',

  toggle: function() {
    this.writeAttribute('active', !this.get('active'));
    this.commitRecord({ owner_name: this.get('owner_name'), name: this.get('name') });
  },

  urlGithubAdmin: function() {
    return this.get('url') + '/admin/hooks#travis_minibucket';
  }.property('slug').cacheable(),
});

Travis.ServiceHook.reopenClass({
  resource: 'profile/service_hooks'
});

Travis.WorkerGroup = Ember.Object.extend({
  init: function() {
    this.set('workers', []);
  },

  host: function() {
    return this.getPath('workers.firstObject.host');
  }.property(),

  add: function(worker) {
    this.get('workers').push(worker);
  }
});

Travis.Worker = Travis.Record.extend({
  isTesting: function() {
    return this.get('state') == 'working' && !!this.getPath('payload.config');
  }.property('state', 'config'),

  number: function() {
    return this.get('name').match(/\d+$/)[0];
  }.property('name'),

  display: function() {
    var name = this.get('name').replace('travis-', '');
    var state = this.get('state');
    var payload = this.get('payload');

    if(state == 'working' && payload != undefined) {
      var repository = payload.repository ? $.truncate(payload.repository.slug, 18) : undefined;
      var number = payload.build && payload.build.number ? ' #' + payload.build.number : '';
      var state = repository ? repository + number : state;
    }

    return name + ': ' + state;
  }.property('state'),

  urlJob: function() {
    return '#!/' + this.getPath('payload.repository.slug') + '/jobs/' + this.getPath('payload.build.id');
  }.property('state', 'payload')
});

Travis.Worker.reopenClass({
  resource: 'workers'
});

var Travis = Ember.Application.create({
  Controllers: { Repositories: {}, Builds: {}, Jobs: {} }, Models: {}, Helpers: {}, Views: {},

  store: Ember.Store.create().from('Travis.DataSource'),

  run: function() {
    var action = $('body').attr('id');
    if (this[action]) {
      this[action]();
    }
    this.initEvents();
  },

  home: function() {
    Ember.routes.add('!/:owner/:name/jobs/:id', function(params) {
      Travis.set('params', params);
      Travis.transitionTo('#job_page');
    });

    Ember.routes.add('!/:owner/:name/builds/:id', function(params) {
      Travis.set('params', params);
      Travis.transitionTo('#jobs_list');
    });

    Ember.routes.add('!/:owner/:name', function(params) {
      Travis.set('params', params);
      Travis.transitionTo('#builds_list');
    });

    Ember.routes.add('', function(params) {
      Travis.set('params', params);
      Travis.transitionTo('#repositories_list');
    });

    // Ember.routes.add('!/:owner/:name/jobs/:id',   function(params) { Travis.main.activate('job',    params) });
    // Ember.routes.add('!/:owner/:name/builds/:id', function(params) { Travis.main.activate('build',  params) });
    // Ember.routes.add('!/:owner/:name/builds',     function(params) { Travis.main.activate('builds', params) });
    // Ember.routes.add('!/:owner/:name',            function(params) { Travis.main.activate('builds', params) });
    // Ember.routes.add('',                          function(params) { Travis.main.activate('list',   params) });

  },

  initEvents: function() {
    $('.fold').live('click', function() { $(this).toggleClass('open'); });
  },

  startLoading: function() {
  },

  stopLoading: function() {
  },

  transitionTo: function(page_selector) {
    var newPage = $(page_selector);
    var oldPage = this.get('currentPage');

    if (oldPage) {
      oldPage.removeClass('active').addClass('inactive');
    }
    newPage.removeClass('inactive').addClass('active');

    this.set('currentPage', newPage);
  }
});

$(function() {
  Travis.run();
});

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});

if (window.console && window.console.log) {
  // Pusher.log = function(message) { window.console.log(arguments); };
}
Travis.Controllers.Builds.List = Ember.ArrayController.create({
  repositoryBinding: '_repositories.firstObject',
  buildsBinding: 'repository.builds',

  lastStatus: function() {
    return 'status ' + this.getPath('builds.firstObject.color');
  }.property('builds.firstObject.color'),

  _repositories: function() {
    var slug = this.get('_slug');
    return slug ? Travis.Repository.bySlug(slug) : Travis.Repository.recent();
  }.property('_slug'),

  _slug: function() {
    var parts = $.compact([this.getPath('Travis.params.owner'), this.getPath('Travis.params.name')]);
    if(parts.length > 0) return parts.join('/');
  }.property('Travis.params')
});
Travis.Controllers.Builds.Show = Ember.Object.create({
  repositoryBinding: 'Travis.Controllers.Builds.List.repository',
  content: function() {
    var build_id = this.getPath('Travis.params.id');
    if (build_id) {
      if (build_id == this.get('build_id')) {
        return this.get('build');
      }
      var build = Travis.Build.find(this.getPath('Travis.params.id'));
      // A hack, but "necessary" to get all the attributes (just not the stuff
      // listen in /builds.
      build.refresh();
      this.set('build', build);
      this.set('build_id', build.get('id'));
      return build;
    } else {
      return undefined;
    }
  }.property('Travis.params')
});
Travis.Controllers.Jobs.Show = Ember.Object.create({
  repositoryBinding: 'Travis.Controllers.Builds.List.repository',
  content: function() {
    var build_id = this.getPath('Travis.params.id');
    if (build_id) {
      if (build_id == this.get('job_id')) {
        return this.get('job');
      }
      var build = Travis.Job.find(this.getPath('Travis.params.id'));
      // A hack, but "necessary" to get all the attributes (just not the stuff
      // listen in /builds.
      build.refresh();
      this.set('job', build);
      this.set('job_id', build.get('id'));
      return build;
    } else {
      return undefined;
    }
  }.property('Travis.params')
});
Travis.Controllers.Repositories.List = Ember.ArrayController.create({
  content: Travis.Repository.recent()
});
Travis.Views.MobileBaseView = Ember.View.extend({
  attributeBindings: ['data-role']
});

Travis.Views.PageView = Travis.Views.MobileBaseView.extend({
  'data-role': 'page',

  didInsertElement: function() {
    var _self = this;
    Ember.run.next(function() {
      _self.$().page();
    });
  }
});

Travis.Views.ToolbarBaseView = Travis.Views.MobileBaseView.extend({
  attributeBindings: ['data-position'],
  'data-position': function() {
    if (this.get('isFullScreen')) {
      return 'fullscreen';
    }

    if (this.get('isFixed')) {
      return 'fixed';
    }
    return '';
  }.property('isFixed', 'isFullScreen').cacheable(),

  isFixed: true,
  isFullScreen: false
});

Travis.Views.HeaderView = Travis.Views.ToolbarBaseView.extend({
  'data-role': 'header'
});

Travis.Views.ContentView = Travis.Views.MobileBaseView.extend({
  'data-role': 'content'
});

Travis.Views.FooterView = Travis.Views.MobileBaseView.extend({
  'data-role': 'footer'
});

Travis.Views.ListItemView = Ember.View.extend({
  tagName: 'li'
});

Travis.Views.ListView = Ember.CollectionView.extend({
  attributeBindings: ['data-role'],
  'data-role': 'listview',
  tagName: 'ul',
  itemViewClass: Travis.Views.ListItemView,

  contentLengthDidChange: function() {
    var _self = this;
    Ember.run.next(function() {
      _self.$().listview();
    });
  }.observes('content.length')
});

Travis.Views.Button = Ember.Button.extend({});
//= require vendor/jquery-1.7.js
//= require vendor/jquery.timeago.js
//= require vendor/jquery.cookie.js
//= require vendor/jquery.tipsy.js
//= require vendor/ember-0.9.6.min.js
//= require vendor/sproutcore-datastore.js
//= require_tree ./vendor/sproutcore-2.0
//= require vendor/pusher-1.6.min.js
//= require vendor/highcharts.js
//= require vendor/ansiparse.js
//= require vendor/facebox.js

