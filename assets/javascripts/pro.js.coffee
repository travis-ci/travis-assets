$.extend Travis.Controllers.Sidebar.proto(),
  init: -> {}

$.extend Travis.Controllers.Repositories.Show.proto(),
  _updateGithubStats: -> {},

  _updateGithubBranches: (->
    selector = $(@branchSelector)
    selector.empty()
    $('.tools input').val('')
    $('<option>', { value: 'master' }).html('master').appendTo(selector);
    @_updateStatusImageCodes()).observes('repository.slug'),

$('document').ready ->
  Travis.channel_prefix = 'private-'
  Travis.secureUrl = (url) ->
    token = $('meta[name=travis-token]').attr('value')
    "https://#{document.domain}/#{url}&token=#{token}"

  unless(typeof TRAVIS_PRO_CHANNELS == 'undefined')
    $.each(TRAVIS_PRO_CHANNELS, (ix, channel) ->
      Travis.subscribe(channel))

# Pusher.log = (message) -> window.console.log(arguments)

