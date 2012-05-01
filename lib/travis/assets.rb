require 'digest/md5'

module Travis
  module Assets
    autoload :TiltFilter, 'travis/assets/tilt_filter'
    autoload :Engine,     'travis/assets/engine'

    class << self
      def version
        File.read('VERSION')
      end

      def write_version
        digest.to_s[0..7].tap do |version|
          File.open('VERSION', 'w+') { |f| f.write(version) }
        end
      end

      def digest
        Digest::MD5.new << `ls -lR assets`
      end
    end
  end
end
