$.extend Travis.Controllers.Sidebar.proto(),
  init: -> {}

$.extend Travis.Controllers.Repositories.Show.proto(),
  _updateGithubStats: -> {},
  _updateGithubBranches: -> {},
  _updateStatusImageCodes: -> {}

$('document').ready ->
  Travis.channel_prefix = 'private-'

  unless(typeof TRAVIS_PRO_CHANNELS == 'undefined')
    $.each(TRAVIS_PRO_CHANNELS, (ix, channel) ->
      Travis.subscribe(channel))

# Pusher.log = (message) -> window.console.log(arguments)

