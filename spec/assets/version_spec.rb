require 'spec_helper'

describe Travis::Assets::Version do
  include Support::Setup

  subject { Travis::Assets::Version.new(root) }

  setup do
    asset 'javascripts/application.js'
  end

  describe 'hash' do
    it 'returns the version hash' do
      subject.hash.should == subject.hash
    end

    it 'does not update' do
      hash = subject.hash
      touch('javascripts/application.js', Time.now + 3600)
      hash.should == subject.hash
    end
  end

  describe 'update' do
    it 'updates the version hash' do
      hash = subject.hash
      touch('javascripts/application.js', Time.now + 3600)
      subject.update
      hash.should_not == subject.hash
    end

    it 'writes out the current version to public/current' do
      version = subject
      version.update
      root.join('public/current').read.should == version.hash
    end
  end
end
