require 'rails'

module Travis
  class Assets < Rails::Railtie
    config.root = Pathname.new(File.expand_path('../../..', __FILE__))

    initializer 'add paths' do |app|
      ['', 'images', 'javascripts', 'stylesheets'].each do |path|
        app.assets.prepend_path(config.root.join('app/assets').join(path).to_s)
      end
    end

    initializer 'add assets to precompile', :group => :all do |app|
      app.config.assets.precompile += %w(application.js application.css)
    end
  end
end
