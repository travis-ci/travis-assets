module Travis
  class Assets
    class Middleware
      class Asset
        attr_reader :root, :path, :versions, :current

        def initialize(root, path, versions, current)
          @root = root
          @path = path
          @versions = versions
          @current = current

          # puts "current #{current}"
          # puts "version #{version}"
          # puts "serve? #{serve?.inspect}"
          # puts "redirect? #{redirect?.inspect}"
          # puts "version? #{version?.inspect}"
          # puts "outdated? #{outdated?.inspect}"
        end

        def serve?
          image? || current? || path == '/current'
        end

        def redirect?
          version? && outdated?
        end

        def current_path
          path.sub(version, current)
        end

        protected

          def image?
            path =~ %r(^/([\w]+)/images/)
          end

          def current?
            version == current
          end

          def outdated?
            !current?
          end

          def version
            @version ||= path =~ %r(^/([\w]+)/(?:images|javascripts|stylesheets|static)) && $1
          end

          def version?
            !!version
          end
      end
    end
  end
end
