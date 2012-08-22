Handlebars.registerHelper('whats_this', function(id) {
    return new Handlebars.SafeString('<span title="What\'s This?" class="whats_this" onclick="$.facebox({ div: \'#'+id+'\'})">&nbsp;</span>');
});

Handlebars.registerHelper('tipsy', function(text, tip) {
  return new Handlebars.SafeString('<span class="tool-tip" original-title="'+tip+'">'+text+'</span>');
});

Handlebars.registerHelper('i18n', function(key, options) {
  var self = this,
      attrs = options.hash,
      i18nOptions = {};
  
  Ember.ArrayUtils.forEach(Ember.keys(attrs), function(attr) {
    var property = attrs[attr];
    if(typeof (property) === 'string') {
      i18nOptions[attr] = Ember.Handlebars.getPath(self, property);
    }
  });
  
  return new Handlebars.SafeString(I18n.t(key, i18nOptions));
});