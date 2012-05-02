require 'rails'
require 'travis/assets'

module Travis
  module Assets
    class Railtie < Rails::Engine
      initializer 'travis.assets.middleware' do
        unless Rails.env.production?
          require 'rake-pipeline/middleware'
          config.app_middleware.insert ActionDispatch::Static, Rake::Pipeline::Middleware, "#{Travis::Assets.root}/AssetFile"
        end
      end
    end
  end
end
