Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    this.set('content', Travis.ServiceHook.all({ orderBy: 'owner_name, name' }));
    this.set('isSyncing', true);
    this.poll();
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url'),

  poll: function() {
    $.get('/profile.json', function(user) {
      if(user.in_sync) {
        var attrs = { recordType: Travis.ServiceHook, options: { orderBy: 'owner_name, name' } };
        var query = Travis.Query.create(attrs).toScQuery('remote');
        Travis.store.find(query);
        this.set('isSyncing', false);
      } else {
        Ember.run.later(this, this.poll.bind(this), 3000);
      }
    }.bind(this));
    // this.schedule_polling();
  }
});

