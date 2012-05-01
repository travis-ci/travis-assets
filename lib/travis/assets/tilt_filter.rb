module Travis
  module Assets
    class TiltFilter < Rake::Pipeline::Web::Filters::TiltFilter
      def initialize(*args)
        super({}, self)
      end

      def asset_path(path)
        "#{Travis::Assets.version}/#{path}"
      end
    end
  end
end
