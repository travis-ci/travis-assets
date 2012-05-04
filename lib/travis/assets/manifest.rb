module Travis
  class Assets
    class Manifest
      attr_reader :root

      def initialize(root)
        @root = root
      end

      def paths(base)
        lines.map { |pattern| expand(base, pattern) }.flatten
      end

      protected

        def expand(base, pattern)
          base  = root.join('assets').join(base)
          paths = Dir[base.join(pattern).to_s]
          paths.map { |path| path.gsub("#{base}/", '') }
        end

        def lines
          read.split("\n").map(&:strip).reject { |path| path.empty? }
        end

        def read
          root.join('Manifest').read
        end
    end
  end
end
