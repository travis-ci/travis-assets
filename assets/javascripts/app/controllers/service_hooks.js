Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    this.poll();
    this.schedule_polling();
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url'),

  poll: function() {
    if(!this.getPath('content.length')) {
      var attrs = { recordType: Travis.ServiceHook, options: { orderBy: 'active DESC, owner_name, name' } };
      var query = Travis.Query.create(attrs).toScQuery('remote');
      this.set('content', Travis.store.find(query));
      this.schedule_polling();
    }
  },

  schedule_polling: function() {
    Ember.run.later(this, this.poll.bind(this), 3000);
  }
});

