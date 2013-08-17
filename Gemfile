source 'https://rubygems.org'

gem 'sinatra'
gem 'unicorn'

group :assets do
  gem 'rake-pipeline', :git => 'https://github.com/livingsocial/rake-pipeline.git'
  gem 'rake-pipeline-web-filters', :git => 'https://github.com/wycats/rake-pipeline-web-filters.git'

  gem 'coffee-script'
  gem 'compass',            '0.12.alpha.4'
  gem 'i18n-js',            '~> 2.1.2'
  gem 'localeapp-i18n-js',  :git => 'git://github.com/randym/localeapp-i18n-js'
end

group :development do
  gem 'faraday'
  gem 'rake'
end

group :test do
  gem 'rspec'
  gem 'mocha'
  gem 'guard-rspec'
  gem 'jasmine',           git: 'git://github.com/pivotal/jasmine-gem', submodules: true
  gem 'webmock',           '~> 1.7.7'
end
