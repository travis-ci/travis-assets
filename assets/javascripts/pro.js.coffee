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
  $('#tab_recent').remove()

  Travis.channel_prefix = 'private-'
  Travis.secureUrl = (path) ->
    token = $('meta[name=travis-token]').attr('value')
    separator = if path.indexOf('?') > -1 then '&' else '?'
    "https://#{document.domain}/#{path}#{separator}token=#{token}"

  unless(typeof TRAVIS_PRO_CHANNELS == 'undefined')
    $.each(TRAVIS_PRO_CHANNELS, (ix, channel) ->
      Travis.subscribe(channel))

# Pusher.log = (message) -> window.console.log(arguments)

