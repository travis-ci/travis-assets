require 'spec_helper'
require 'fileutils'

describe Travis::Assets::Manifest do
  include Support::Setup

  subject { Travis::Assets::Manifest.new(root) }

  describe 'paths' do
    describe 'given the manifest file contains the line application.js' do
      setup do
        manifest 'application.js'
        asset 'javascripts/application.js'
      end

      it 'returns the path to the asset relative to the given assets subdir' do
        subject.paths('javascripts').should include('application.js')
      end
    end

    describe 'given the manifest file contains the line **/*.js' do
      setup do
        manifest '**/*.js'
        asset 'javascripts/foo/bar.js'
      end

      it 'returns the path to the asset relative to the given assets subdir' do
        subject.paths('javascripts').should include('foo/bar.js')
      end
    end
  end
end
