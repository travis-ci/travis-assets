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

  resultMessage: function() {
    return this.messageForResult(this.get('result'));
  }.property('result').cacheable(),

  // VIEW HELPERS

  formattedDuration: function() {
    return this._formattedDuration()
  }.property('duration', 'started_at', 'finished_at'),

  formattedFinishedAt: function() {
    return this._formattedFinishedAt();
  }.property('finished_at').cacheable(),

  formattedCommit: function() {
    return (this.get('commit') || '').substr(0,7);
  }.property('commit').cacheable(),

  formattedCommitAndBranch: function() {
    return this._formattedCommit();
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

  formattedMatrixHeaders: function() {
    var keys = $.keys($.only(this.get('config'), 'rvm', 'gemfile', 'env', 'otp_release', 'php', 'node_js', 'perl', 'python', 'scala', 'jdk', 'compiler', 'go'));
    return $.map([I18n.t("build.job"), I18n.t("build.duration"), I18n.t("build.finished_at")].concat(keys), function(key) { return $.camelize(key) });
  }.property('config').cacheable(),

  formattedMessage: function(){
    return this._formattedMessage();
  }.property('message'),

  shortMessage: function(){
    return this._shortMessage();
  }.property('message'),

  messageBody: function(){
	return this._messageBody();
  }.property('message'),

  url: function() {
    return '#!/' + this.getPath('repository.slug') + '/builds/' + this.get('id');
  }.property('repository.status', 'id'),

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
  }.property('repository.slug', 'commit').cacheable()
});

Travis.Build.reopenClass({
  resource: 'builds',

  pushesByRepositoryId: function(id, parameters) {
    return this.all({ url: '/builds.json?repository_id=%@&bare=true'.fmt(id), repository_id: id, orderBy: 'number DESC', event_type: 'push' });
  },

  pullRequestsByRepositoryId: function(id, parameters) {
    return this.all({ url: '/builds.json?repository_id=%@&bare=true&event_type=pull_request'.fmt(id), repository_id: id, orderBy: 'number DESC', event_type: 'pull_request' });
  },

  olderThanNumber: function(id, build_number) {
    return this.all({ url: '/builds.json?repository_id=%@&bare=true&after_number=%@'.fmt(id, build_number), repository_id: id, orderBy: 'number DESC' });
  }
});
