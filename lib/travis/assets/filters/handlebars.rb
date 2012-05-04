module Travis
  class Assets
    module Filters
      class Handlebars < Rake::Pipeline::Web::Filters::HandlebarsFilter
        def initialize(*args)
          super(:key_name_proc => method(:key_name))
        end

        def key_name(input)
          input.path.gsub(%r(\.[\w\.]+$), '')
        end
      end
    end
  end
end
