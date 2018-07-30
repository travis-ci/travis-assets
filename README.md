# travis-assets

Serves two purposes:

* serve assets on http://assets.travis-ci.org in production
* act as a Rails engine in development mode so that assets are directly served from the travis-ci Rails app

## Modifying assets in development

When you're working on [travis-ci](https://github.com/travis-ci/travis-ci) locally and want to see your asset 
modifications immediately on your locally running version, in your local travis-ci's `Gemfile` change the 
reference of `travis-assets` from `git` to your local checkout, like so:

    #gem 'travis-assets',  git: 'https://github.com/travis-ci/travis-assets', require: 'travis/assets/railtie'
    gem 'travis-assets', path: '../travis-assets', require: 'travis/assets/railtie'
    
Re-`bundle` travis-ci and in travis-assets, run `bundle exec guard`. This will recompile your assets whenever you
modify something, and your running instance of travis-ci should pick them up automatically.

## Running the tests

Integration tests are implemented using [Jasmine](https://jasmine.github.io/) and can be run in the browser.

To run the whole test suite, simply do:

```
$ bundle install # Only needed on the first run
$ bundle exec rake jasmine:ci
```
