Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    this.set('content', Travis.ServiceHook.all({ orderBy: 'owner_name, name' }));

    this.sync();
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url'),

  sync: function() {
    $.post('/profile/sync', function(user) {
      this.set('isSyncing', true);
      this.poll();
    }.bind(this));
  },

  poll: function() {
    $.get('/profile.json', function(user) {
      if(user.is_syncing == 'f') {
        user.is_syncing = false;
      }
      this.set('isSyncing', user.is_syncing);
      if(!user.is_syncing) {
        var attrs = { recordType: Travis.ServiceHook, options: { orderBy: 'owner_name, name' } };
        var query = Travis.Query.create(attrs).toScQuery('remote');
        Travis.store.find(query);
      } else {
        Ember.run.later(this, this.poll.bind(this), 3000);
      }
    }.bind(this));
  }
});

