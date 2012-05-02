require 'pathname'
require 'digest/md5'

module Travis
  module Assets
    autoload :Filters, 'travis/assets/filters'
    autoload :I18n,    'travis/assets/i18n'
    autoload :Railtie, 'travis/assets/railtie'

    VERSION_FILE = 'public/current'
    KEEP_VERSIONS = 3

    class << self
      def version=(version)
        @version = version
        version_file.open('w+') { |f| f.write(version) }
      end

      def version
        @version ||= version_file.read
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../..', __FILE__))
      end

      def clear
        versions[0..-(KEEP_VERSIONS + 1)].each do |version|
          `rm -rf #{root}/public/#{version}`
        end
      end

      def paths(base)
        manifest.map { |path| expand(base, path) }.flatten
      end

      protected

        def version_file
          @version_file ||= root.join(VERSION_FILE)
        end

        def versions
          `ls -tr1 #{root.join('public')}`.split("\n")
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
