Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    this.poll();
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url'),

  sync: function() {
    this.set('content', []);
    this.set('isSyncing', true);
    $.post('/profile/sync', this.poll.bind(this));
  },

  poll: function() {
    $.get('/profile.json', function(user) {
      if(user.is_syncing == 'f') user.is_syncing = false;
      this.set('isSyncing', user.is_syncing);
      this.set('syncedAt', Travis.Helpers.Common.timeAgoInWords(user.synced_at) || '?');

      if(!user.is_syncing) {
        var owner_name = location.href.split('/').slice(-2)[0];
        var attrs = { recordType: Travis.ServiceHook, options: { owner_name: owner_name, orderBy: 'name' } };
        var query = Travis.Query.create(attrs).toScQuery('remote');
        this.set('content', Travis.store.find(query));
      } else {
        this.set('content', []);
        Ember.run.later(this, this.poll.bind(this), 3000);
      }
    }.bind(this));
  }
});

