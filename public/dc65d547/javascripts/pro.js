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
    $('#tab_recent').remove();
    Travis.channel_prefix = 'private-';
    Travis.secureUrl = function(path) {
      var separator, token;
      token = $('meta[name=travis-token]').attr('value');
      separator = path.indexOf('?') > -1 ? '&' : '?';
      return "https://" + document.domain + "/" + path + separator + "token=" + token;
    };
    if (!(typeof TRAVIS_PRO_CHANNELS === 'undefined')) {
      return $.each(TRAVIS_PRO_CHANNELS, function(ix, channel) {
        return Travis.subscribe(channel);
      });
    }
  });

}).call(this);
