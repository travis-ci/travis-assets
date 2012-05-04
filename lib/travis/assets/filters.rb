module Travis
  class Assets
    module Filters
      autoload :Handlebars, 'travis/assets/filters/handlebars'
      autoload :Tilt,       'travis/assets/filters/tilt'
    end
  end
end
