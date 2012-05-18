# __DEBUG__ = true
# Ember.LOG_BINDINGS = true
# Pusher.log = () -> window.console.log(arguments) if window.console && window.console.log

@Travis.app = Travis.AppController.create()

$ ->
  Travis.app.run() if window.env != undefined && window.env != 'jasmine'

$.ajaxSetup
  beforeSend: (xhr) ->
    if !this.url || this.url.indexOf(document.location.host) > -1
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

# $.facebox.settings.closeImage = '/images/facebox/closelabel.png'
# $.facebox.settings.loadingImage = '/images/facebox/loading.gif'

