module Travis
  class Assets
    module Dsl
      class Project < Rake::Pipeline::DSL::ProjectDSL
        def output(path)
          project.default_output_root = project.root.join(path)
        end

        def tmpdir(path)
          project.tmpdir = project.root.join(path)
        end

        def input(*inputs, &block)
          inputs[0] = project.root.join(inputs[0]).to_s unless inputs.empty?
          super
        end
      end
    end
  end
end
