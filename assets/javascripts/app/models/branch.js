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
