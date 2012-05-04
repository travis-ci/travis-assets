module Travis
  class Assets
    module Filters
      class Tilt < Rake::Pipeline::Web::Filters::TiltFilter
        def initialize(*args)
          super({}, self)
        end

        def asset_path(path)
          puts "using version #{version}"
          "/#{version}/#{path}"
        end

        protected

          def version
            @version ||= Travis::Assets.version
          end
      end
    end
  end
end
