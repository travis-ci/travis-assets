Travis.Controllers.Repositories.BranchSummary = Ember.Object.extend({
  repositoryBinding: 'parent.repository',

  init: function() {
    this._super();
    this.view = Ember.View.create({
      controller: this,
      branchesBinding: 'controller.repository.branchSummary',
      templateName: 'app/templates/repositories/branch_summary',
      click: function(e){
        var buildUrl = $(e.target).closest('tr').find('.number a').attr('href');
        if (buildUrl) { window.location = buildUrl };
      }
    });
  },

  destroy: function() {
    // console.log('destroying list in: ' + this.selector + ' .details')
    if(this.view) {
      this.view.$().remove();
      this.view.destroy();
    }
  },
});
