require 'sinatra'

class App < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
    set :public_folder, lambda { "#{root}/public" }
  end

  configure :development do
    $: << 'lib'
    require 'travis/assets'
    require 'rake-pipeline'
    require 'rake-pipeline/middleware'
    use Rake::Pipeline::Middleware, "#{settings.root}/AssetFile"
  end

  not_found do
    'Not found.'
  end
end

run App
