require 'digest/md5'

module Travis
  module Assets
    class Version
      FILE = 'public/current'

      attr_reader :root

      def initialize(root)
        @root = root
      end

      def version
        @version ||= digest.to_s[0..7]
      end

      def update
        write
      end

      protected

        def file
          @version_file ||= root.join(FILE)
        end

        def write
          file.open('w+') { |f| f.write(version) }
          self
        end

        def digest
          Digest::MD5.new << `ls -alR AssetFile Gemfile.lock #{root}/assets`
        end
    end
  end
end
