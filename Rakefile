require 'rubygems'
require 'bundler/setup'
require 'rake-pipeline'

namespace :assets do
  desc "Precompile assets using Rake::Pipeline"
  task :precompile do
    Rake::Pipeline::Project.new('Assetfile').invoke
  end
end
