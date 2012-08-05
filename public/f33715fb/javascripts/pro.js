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
    _updateGithubBranches: function() {
      return {};
    },
    _updateStatusImageCodes: function() {
      return {};
    }
  });

  $('document').ready(function() {
    Travis.channel_prefix = 'private-';
    if (!(typeof TRAVIS_PRO_CHANNELS === 'undefined')) {
      return $.each(TRAVIS_PRO_CHANNELS, function(ix, channel) {
        return Travis.subscribe(channel);
      });
    }
  });

}).call(this);
