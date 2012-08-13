(function() {

  $.extend(Travis.Controllers.Sidebar.proto(), {
    init: function() {
      return {};
    }
  });

  $.extend(Travis.Controllers.Repositories.Show.proto(), {
    _updateGithubStats: function() {
      return {};
    },
    _updateGithubBranches: (function() {
      var selector;
      selector = $(this.branchSelector);
      selector.empty();
      $('.tools input').val('');
      $('<option>', {
        value: 'master'
      }).html('master').appendTo(selector);
      return this._updateStatusImageCodes();
    }).observes('repository.slug')
  });

  $('document').ready(function() {
    Travis.channel_prefix = 'private-';
    Travis.secureUrl = function(url) {
      return "https://" + document.domain + "/" + url;
    };
    if (!(typeof TRAVIS_PRO_CHANNELS === 'undefined')) {
      return $.each(TRAVIS_PRO_CHANNELS, function(ix, channel) {
        return Travis.subscribe(channel);
      });
    }
  });

}).call(this);
