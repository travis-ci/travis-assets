require 'spec_helper'
require 'rake-pipeline'

describe 'AssetFile' do
  describe 'stylesheets' do
    include Support::Setup

    setup

    let(:project) { Travis::Assets::Project.new(root) }

    before :each do
      Travis::Assets.root = root
    end

    it 'sets the output dir to the absolute version dir in the public path' do
      project.default_output_root.should =~ %r(#{root.join('public').expand_path.to_s}/[\w]{7})
    end

    it 'sets the tmp dir to the absolute tmp path' do
      project.tmpdir.should == root.join('tmp').expand_path.to_s
    end

    describe 'the manifest pipeline' do
      let(:pipeline) { project.pipelines.first }

      it 'includes a .js file' do
        asset 'javascripts/app.js'
        pipeline.inputs.values.first.should == '{app.js}'
      end

      it 'includes a .js.coffee file' do
        asset 'javascripts/sponsors.js.coffee'
        project.pipelines.first.inputs.values.first.should == '{sponsors.js.coffee}'
      end

      it 'includes files from lib/' do
        asset 'javascripts/lib/foo.js'
        project.pipelines.first.inputs.values.first.should == '{lib/foo.js}'
      end

      it 'includes jst.hjs templates' do
        asset 'javascripts/app/templates/foo.jst.hjs'
        project.pipelines.first.inputs.values.first.should == '{app/templates/foo.jst.hjs}'
      end
    end
  end
end
