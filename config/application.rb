require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module TravisAssets
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    # config.assets.version = '1.0'

    # config.serve_static_assets = true
    # config.static_cache_control = "public, max-age=31536000"

    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('locales', '*.{rb,yml}').to_s]
  end
end
