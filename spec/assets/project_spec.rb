require 'spec_helper'

describe Travis::Assets::Project do
  include Support::Setup

  setup

  describe 'build' do
    it 'evaluates the given block within the context of a Travis::Assets::Dsl::Project instance' do
      build_context = nil
      Travis::Assets::Project.build(root) { build_context = self }
      build_context.should be_instance_of(Travis::Assets::Dsl::Project)
    end
  end

  describe 'output' do
    it 'prepends the current root' do
      project = Travis::Assets::Project.build(root) { output 'public' }
      project.default_output_root.should == root.join('public').expand_path.to_s
    end
  end

  describe 'tmpdir' do
    it 'prepends the current root' do
      project = Travis::Assets::Project.build(root) { tmpdir 'tmpdir' }
      project.tmpdir.should == root.join('tmpdir').expand_path.to_s
    end
  end

  describe 'input' do
    it 'prepends the current root' do
      project = Travis::Assets::Project.build(root) { input 'javascripts', 'foo.js' }
      project.pipelines.first.inputs.should == { root.join('javascripts').to_s => 'foo.js' }
    end
  end
end
