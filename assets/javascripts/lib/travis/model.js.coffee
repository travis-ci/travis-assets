window.Travis = Ember.Namespace.create()  if 'undefined' is typeof window.Travis

window.Travis.Model = DS.Model.extend
  primaryKey: 'id'
  id: DS.attr('number')

  refresh: ->
    id = @get('id')
    Travis.app.store.adapter.find(Travis.app.store, @constructor, id) if id

  update: (attrs) ->
    $.each attrs, (key, value) =>
      @set(key, value) unless key is 'id'
    this

window.Travis.Model.reopenClass
  find: (id, callback) ->
    throw ('id is undefined') if id is undefined
    Travis.app.store.find(this, id)

  all: (query) ->
    Travis.app.store.find(this, query)

  load: (attrs) ->
    Travis.app.store.load(this, attrs)
