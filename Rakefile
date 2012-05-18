$: << 'lib'

require 'rubygems'
require 'bundler/setup'
require 'travis/assets'
require 'faraday'

namespace :assets do
  # this task is named compile, not precompile, so that heroku won't try to run it
  desc "Precompile assets using Rake::Pipeline"
  task :compile do
    # Travis::Assets::I18n.export # TODO turn this shit into a filter

    Travis::Assets.update_version
    puts "Assets version: #{Travis::Assets.version}"

    Travis::Assets::Project.new(File.dirname(__FILE__)).invoke
    Travis::Assets.update_version

    # TODO move this to a pipeline in AssetFile
    require 'pathname'
    require 'fileutils'

    fetch = ->(url) do
      response = Faraday.get(url)
      raise("can not fetch #{url}") unless response.success?
      response.body
    end

    begin
      hosts = %w(
        travis-assets.herokuapp.com
        travis-assets-staging.herokuapp.com
      )

      current = hosts.map do |host|
        fetch.call("http://#{host}/current")
      end

      Travis::Assets.expire(keep: current)
    rescue SocketError => e
    end
  end
end
