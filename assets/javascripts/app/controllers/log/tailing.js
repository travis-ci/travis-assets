Travis.Controllers.Log = Ember.Namespace.create();

Travis.Controllers.Log.Tailing = Ember.Object.extend({
  cookie: 'tail_logs',

  options: {
    timeout: 200,
    offset: {
      top: -200,
      left: 0
    },
    easing: {
      duration: 100,
      type: 'swing'
    }
  },

  init: function() {
    Ember.run.later(this.run.bind(this), this.options.timeout);
    // Ember.run.later(this.watchScrolling.bind(this), 1000);
    $(window).scroll(function(event) {
      // if(this.get('active')) {
      //   event.stopPropagation();
      //   event.stopImmediatePropagation();
      //   event.preventDefault();
      // };
    });
  },

  run: function() {
    this.scroll();
    Ember.run.later(this.run.bind(this), this.options.timeout);
  },

  active: function() {
    return $('#tail').hasClass('active');
    // return $.cookie(this.cookie) === 'true';
  }.property(),

  toggle: function(event) {
    this.get('active') ? this.stop() : this.start();
    event.preventDefault();
  },

  start: function() {
    // this.persist(true);
    $('#tail').addClass('active');
  },

  stop: function() {
    // this.persist(false);
    $('#tail').removeClass('active');
  },

  // persist: function(tailing) {
  //   $.cookie(this.cookie, tailing);
  //   this.notifyPropertyChange('active');
  // },

  scroll: function() {
    if(this.get('active')) {
      this.autoScrolling = true;
      $(window).stop();
      $(window).scrollTo('#tail', this.options.easing.duration, {
        offset: this.options.offset,
        easing: this.options.easing.type,
        onAfter: function() { this.autoScrolling = false; }.bind(this)
      })
    }
  },

  watchScrolling: function() {
    $(document).scroll(this.onScroll.bind(this));
  },

  onScroll: function() {
    if(!this.autoScrolling && this.get('active')) {
      this.stop();
    }
  },
});
