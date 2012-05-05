require 'pathname'
require 'singleton'
require 'forwardable'
require 'rake-pipeline'

module Travis
  class Assets
    autoload :Filters,    'travis/assets/filters'
    autoload :I18n,       'travis/assets/i18n'
    autoload :Manifest,   'travis/assets/manifest'
    autoload :Middleware, 'travis/assets/middleware'
    autoload :Dsl,        'travis/assets/dsl'
    autoload :Project,    'travis/assets/project'
    autoload :Railtie,    'travis/assets/railtie'
    autoload :Version,    'travis/assets/version'

    KEEP_VERSIONS = 3

    include Singleton

    class << self
      extend Forwardable

      attr_writer :root
      def_delegators :instance, :version, :paths, :update_version, :expire, :versions

      def root
        @root ||= Pathname.new(File.expand_path('../../..', __FILE__))
      end
    end

    attr_reader :root, :manifest, :version

    def initialize(root = self.class.root)
      @root = root
      @manifest = Manifest.new(root)
      @version = Version.new(root)
    end

    def paths(base)
      manifest.paths(base)
    end

    def version
      @version.read
    end

    def update_version
      @version.update
    end

    def expire(options = { keep: nil })
      keep = Array(options[:keep])
      expired_versions.each do |version|
        next if keep.include?(version)
        puts "removing expired version #{version}"
        `rm -rf #{root}/public/#{version}`
      end
    end

    def versions
      `ls -tr1 #{root.join('public')}`.split("\n") - ['current']
    end

    protected

      def expired_versions
        Array(versions.reverse[KEEP_VERSIONS..-1])
      end
  end
end
