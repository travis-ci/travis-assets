# travis-assets

Serves two purposes:

* serve assets on http://assets.travis-ci.org in production
* act as a Rails engine in development mode so that assets are directly served from the travis-ci Rails app

## Running the tests

Integration tests are implemented using [Jasmine](http://pivotal.github.com/jasmine) and can be run in the browser.

To run the whole test suite, simply do:

```
$ bundle install # Only needed on the first run
$ bundle exec rake guard:jasmine
```