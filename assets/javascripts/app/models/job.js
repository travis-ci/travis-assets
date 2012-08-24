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

  resultMessage: function() {
    return this.messageForResult(this.get('result'));
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
    return (this.get('commit') || '').substr(0,7);
  }.property('commit').cacheable(),

  formattedCommitAndBranch: function() {
    return this._formattedCommit()
  }.property('commit', 'branch').cacheable(),

  compareToHash: function() {
    return this._compareToHash();
  }.property('compare_url').cacheable(),

  formattedCompareUrl: function() {
    return this._formattedCompareUrl();
  }.property('compare_url').cacheable(),

  formattedConfig: function() {
    return this._formattedConfig();
  }.property('config').cacheable(),

  formattedConfigValues: function() {
    var values = $.values($.only(this.getPath('config'), 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'perl', 'python', 'scala', 'jdk', 'compiler', 'go'));
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

  shortMessage: function(){
    return this._shortMessage();
  }.property('message'),

  messageBody: function(){
	return this._messageBody();
  }.property('message'),
  
  urlAuthor: function() {
    return 'mailto:' + this.get('author_email');
  }.property('author_email').cacheable(),

  gravatarAuthor: function() {
    return this.gravatarUrl(this.get('author_email'), 40);
  }.property('author_email').cacheable(),

  urlCommitter: function() {
    return 'mailto:' + this.get('committer_email');
  }.property('committer_email').cacheable(),

  gravatarCommitter: function() {
    return this.gravatarUrl(this.get('committer_email'), 40);
  }.property('committer_email').cacheable(),

  urlGithubCommit: function() {
    return this._urlGithubCommit();
  }.property('repository.slug', 'commit').cacheable(),

  url: function() {
    return '#!/' + this.getPath('repository.slug') + '/jobs/' + this.get('id');
  }.property('repository', 'id')
});

Travis.Job.reopenClass({
  resource: 'jobs'
});

