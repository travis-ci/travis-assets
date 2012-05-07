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
        end

        def serve?
          current? || path == '/current'
        end

        def redirect?
          version? && outdated?
        end

        def current_path
          path.sub(version, current)
        end

        protected

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
