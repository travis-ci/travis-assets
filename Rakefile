$: << 'lib'

require 'rubygems'
require 'bundler/setup'
require 'travis/assets'

namespace :assets do
  # this task is named compile, not precompile, so that heroku won't try to run it
  desc "Precompile assets using Rake::Pipeline"
  task :compile do
    Travis::Assets::I18n.export # turn this shit into a filter
    Travis::Assets::Project.new(File.dirname(__FILE__)).invoke
    Travis::Assets.expire
  end
end
