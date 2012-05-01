require 'rails'
require 'rake-pipeline/middleware'
require 'travis/assets'

module Travis
  module Assets
    class Railtie < Rails::Engine
      initializer 'travis.assets.middleware' do
        unless Rails.env.production?
          config.app_middleware.insert ActionDispatch::Static, Rake::Pipeline::Middleware, "#{Travis::Assets.root}/AssetFile"
        end
      end
    end
  end
end
