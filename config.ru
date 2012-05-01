$: << 'lib'

require 'travis/assets'
require 'sinatra'

class App < Sinatra::Base
  configure do
    set :root, File.expand_path('.')
    set :public_folder, "#{settings.root}/public}"
    set :cachebust, Digest::SHA1.hexdigest(Travis::Assets.version)

    # compile assets at startup
    system('rake assets:precompile');
  end

  # use rake-pipline middleware during development
  configure :development do
    require 'rake-pipeline'
    require 'rake-pipeline/middleware'
    use Rake::Pipeline::Middleware, "#{settings.root}/AssetFile"
  end

  not_found do
    'Not found.'
  end
end

run App
