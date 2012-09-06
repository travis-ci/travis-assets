Travis.Controllers.Log = Ember.Namespace.create();

Travis.Controllers.Log.Tailing = Ember.Object.extend({
  options: {
    timeout: 200
  },

  init: function() {
    Ember.run.later(this.run.bind(this), this.options.timeout);
    $(window).scroll(function(event) { this.scrollButton(); }.bind(this));
  },

  run: function() {
    this.autoScroll();
    Ember.run.later(this.run.bind(this), this.options.timeout);
  },

  active: function() {
    return $('#tail').hasClass('active');
  }.property(),

  toggle: function(event) {
    this.get('active') ? this.stop() : this.start();
    event.preventDefault();
  },

  start: function() {
    $('#tail').addClass('active');
  },

  stop: function() {
    $('#tail').removeClass('active');
  },

  autoScroll: function() {
    if(this.get('active')) {
      var win = $(window);
      var log = $('#main .log');
      var logBottom = log.offset().top + log.outerHeight() + 40;
      var winBottom = win.scrollTop() + win.height();

      if(logBottom - winBottom > 0) {
        win.scrollTop(logBottom - win.height());
      }
    }
  },

  scrollButton: function() {
    var tail = $('#tail');
    if(tail.length == 0) return;

    var offset = $(window).scrollTop() - $('.log').offset().top;
    var max = $('.log').height() - $('#tail').height() + 5;

    if(offset > max) {
      offset = max;
    }

    if(offset > 0) {
      tail.css({ top: offset - 2 });
    } else {
      tail.css({ top: 0 });
    }
  },
});
