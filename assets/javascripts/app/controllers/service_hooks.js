Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    this.poll();
    Ember.run.later(this, this.poll.bind(this), 3000);
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url'),

  poll: function() {
    if(!this.getPath('content.length')) {
      var content = Travis.ServiceHook.all({ orderBy: 'active DESC, owner_name, name' });
      this.set('content', content);
    }
  }
});

