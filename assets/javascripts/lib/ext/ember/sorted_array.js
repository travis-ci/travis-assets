var get = Ember.get, set = Ember.set;

var compareItems = function(order, item1, item2) {
  var result = 0,
      propertyName, len, i;

  if (typeof order === 'function') {
    result = order.call(null, item1, item2);
  } else {
    len = order ? order.length : 0;
    for (i=0; result===0 && (i < len); i++) {
      propertyName = order[i].propertyName;
      result = Ember.compare(get(item1, propertyName), get(item2, propertyName));
      if ((result !== 0) && order[i].descending) {
        result = (-1) * result;
      }
    }
  }

  if (result !== 0) return result;
};

var orderByProperty = Ember.computed(function(key, value) {
  if (value !== undefined) {
    var o, i, l, p, ps = [];
    if (!value) {
      o = [];
    } else if (typeof value === 'function') {
      o = value;
    } else {
      o = value.split(',');
      for (i = 0, l = o.length; i < l; i++) {
        p = o[i];
        p = p.replace(/^\s+|\s+$/,'');
        p = p.replace(/\s+/,',');
        p = p.split(',');
        ps.push(p[0]);
        o[i] = {propertyName: p[0]};
        if (p[1] && p[1] == 'DESC') o[i].descending = true;
      }
    }
    set(this, 'sortByProperties', ps);
    return o;
  }
});

Ember.SortedArray = Ember.ArrayProxy.extend({

  /**
   * Adds a new item to the list and ensures it is
   * sorted correctly.
   *
   * @param {Ember.Object} item the item to insert.
   */
  insertObject: function(item) {
    var length, idx;

    length = get(this, 'length');
    idx = this.binarySearch(item, 0, length);

    this.insertAt(idx, item);

    // If the value by which we've sorted the item
    // changes, we need to re-insert it at the correct
    // location in the list.
    this.addObserversToItem(item);
  },

  addObject: function(item) {
    if (this.contains(item)) { return; }
    this.insertObject(item);
  },

  replaceObjects: function(items) {
    var remove = [];
    this.forEach(function(item) {
      if (!items.contains(item)) {
        remove.push(item);
      }
    });
    this.removeObjects(remove);
    this.addObjects(items);
  },

  /**
   * Removes an item from the list
   *
   * @param {Ember.Object} item the item to remove
   */
  removeObject: function(item) {
    this._super(item);
    this.removeObserversFromItem(item);
  },

  /**
   * @private
   *
   * Binary search implementation that finds the index
   * where a item should be inserted.
   */
  binarySearch: function(item, low, high) {
    var mid, midItem, res,
        orderBy = get(this, 'orderBy');

    if (low === high) {
      return low;
    }

    mid = low + Math.floor((high - low) / 2);
    midItem = this.objectAt(mid);

    res = compareItems(orderBy, midItem, item);

    if (res < 0) {
      return this.binarySearch(item, mid+1, high);
    } else if (res > 0) {
      return this.binarySearch(item, low, mid);
    }

    return mid;
  },

  /**
   * @private
   *
   * Adjusts the sorting caused by a sort value change in an item.
   *
   * @param item suspect item has changed sort value
   */
  itemOrderByDidChange: function(item) {
    this.removeObject(item);
    this.insertObject(item);
  },

  addObserversToItem: function(item) {
    this.get('sortByProperties').forEach(function(propertyName) {
      Ember.addObserver(item, propertyName, this, 'itemOrderByDidChange');
    }, this);
  },

  removeObserversFromItem: function(item) {
    this.get('sortByProperties').forEach(function(propertyName) {
      Ember.removeObserver(item, propertyName, this, 'itemOrderByDidChange');
    }, this);
  },

  sortByPropertiesWillChange: function() {
    this.forEach(this.removeObserversFromItem, this);
  }.observesBefore('sortByProperties'),

  sortByPropertiesDidChange: function() {
    this.forEach(this.addObserversToItem, this);
  }.observes('sortByProperties'),

  /**
   * @private
   *
   * Checks to see if the 'content' array has been created.  If not,
   * creates it with an empty Ember.array.
   */
  init: function() {
    var orderBy = get(this, 'orderBy');
    this._super();
    Ember.defineProperty(this, 'orderBy', orderByProperty);
    set(this, 'orderBy', orderBy);

    set(this, 'content', Ember.A([]));
  }

});
