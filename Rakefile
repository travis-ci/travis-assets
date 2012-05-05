$: << 'lib'

require 'rubygems'
require 'bundler/setup'
require 'travis/assets'
require 'faraday'

namespace :assets do
  # this task is named compile, not precompile, so that heroku won't try to run it
  desc "Precompile assets using Rake::Pipeline"
  task :compile do
    Travis::Assets::I18n.export # turn this shit into a filter

    Travis::Assets.update_version
    puts "Assets version: #{Travis::Assets.version}"

    # need to do this because the current Travis::Assets.version is rendered
    # into the assets, but rake-pipeline is currently not aware of that change.
    # can we add the current version to pipeline.digest_additions?
    #
    # also, digest_additions might be entirely screwed, because we inherit from
    # Project and it uses an attr_accessor on the class
    `rm -rf tmp/rake-pipeline-*`
    Travis::Assets::Project.new(File.dirname(__FILE__)).invoke

    # TODO move this to a pipeline in AssetFile
    require 'pathname'
    require 'fileutils'

    root   = Pathname.new(File.dirname(__FILE__))
    source = root.join('assets')
    target = root.join("public/#{Travis::Assets.version}")

    `mkdir -p #{target}`
    `cp -r #{source.join('images')} #{target}`


    fetch = ->(url) do
      response = Faraday.get(url)
      raise("can not fetch #{url}") unless response.success?
      response.body
    end

    hosts = %w(
      travis-assets.herokuapp.com
      travis-assets-staging.herokuapp.com
    )

    current = hosts.map do |host|
      fetch.call("http://#{host}/current")
    end

    Travis::Assets.expire(keep: current)
  end
end
