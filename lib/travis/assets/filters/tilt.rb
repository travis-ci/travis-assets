module Travis
  class Assets
    module Filters
      class Tilt < Rake::Pipeline::Web::Filters::TiltFilter
        def initialize(*args)
          super({}, self)
        end

        def asset_path(path)
          "/#{Travis::Assets.version}/#{path}"
        end
      end
    end
  end
end
