$: << 'lib'

require 'sinatra'
require 'rack/ssl'
# require 'travis/assets'

class App < Sinatra::Base
  disable :protection

  set :root, File.dirname(__FILE__)
  set :public_folder, lambda { "#{root}/public" }
  set :static_cache_control, :public

  configure :production do
    use Rack::SSL
    use Rack::Deflater
  end

  get '/' do
    File.new('public/index.html').readlines
  end

  not_found do
    'Not found.'
  end
end

run App
