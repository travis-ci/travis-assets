require 'rubygems'
require 'bundler/setup'
require 'rake-pipeline'

namespace :assets do
  # this task is named compile, not precompile, so that heroku won't try to run it
  desc "Precompile assets using Rake::Pipeline"
  task :compile do
    Rake::Pipeline::Project.new('Assetfile').invoke
  end
end
