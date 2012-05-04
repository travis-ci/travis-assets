require 'rake-pipeline'
require 'pathname'

module Travis
  class Assets
    class Project < Rake::Pipeline::Project
      class << self
        def build(*args, &block)
          project = new(*args, &block)
        end
      end

      attr_reader :root

      def initialize(root, &block)
        @root = Pathname.new(root)
        if block
          super()
          build(&block)
        else
          super(self.root.join('AssetFile').to_s)
        end
      end

      def build(&block)
        Dsl::Project.new(self).instance_eval(&block)
        self
      end
    end
  end
end
