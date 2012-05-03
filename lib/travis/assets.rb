require 'pathname'

module Travis
  module Assets
    autoload :Filters, 'travis/assets/filters'
    autoload :I18n,    'travis/assets/i18n'
    autoload :Railtie, 'travis/assets/railtie'
    autoload :Version, 'travis/assets/version'

    KEEP_VERSIONS = 5

    class << self
      def version
        @version ||= Version.new(root).version
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../..', __FILE__))
      end

      def expire
        expired_versions.each do |version|
          `rm -rf #{root}/public/#{version}`
        end
      end

      def paths(base)
        manifest.map { |path| expand(base, path) }.flatten
      end

      protected

        def expired_versions
          Array(versions.reverse[(KEEP_VERSIONS - 1)..-1])
        end

        def versions
          `ls -tr1 #{root.join('public')}`.split("\n") - ['current']
        end

        def expand(base, path)
          Dir["#{base}/#{path}"].map { |path| path.gsub("#{base}/", '') }
        end

        def manifest
          root.join('Manifest').read.split("\n").map(&:strip).reject { |path| path.empty? }
        end
    end
  end
end
