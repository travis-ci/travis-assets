Travis.Controllers.ServiceHooks = Ember.ArrayController.extend({
  init: function() {
    this._super();
    this.view = Ember.View.create({
      service_hooks: this,
      template: Ember.TEMPLATES['app/templates/service_hooks/list']
    });
    this.view.appendTo('#service_hooks');

    var self = this;
    setTimeout(function() {
      Ember.run(function() {
        var content = Travis.ServiceHook.all({ orderBy: 'active DESC, owner_name, name' });
        self.set('content', content);
      });
    }, 15000);
  },

  state: function() {
    return this.get('active') ? 'on' : 'off';
  }.property('active'),

  githubUrl: function() {
    return '%@/admin/hooks#travis_minibucket'.fmt(this.get('url'));
  }.property('url')
});

