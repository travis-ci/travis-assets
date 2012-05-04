require 'rails'
require 'travis/assets'

module Travis
  class Assets
    class Railtie < Rails::Engine
      initializer 'travis.assets.middleware' do
        register_middleware unless Rails.env.production?
      end

      def register_middleware
        config.app_middleware.insert ActionDispatch::Static, Travis::Assets::Middleware, Travis::Assets.root
      end
    end
  end
end
