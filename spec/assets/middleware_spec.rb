require 'spec_helper'

describe Travis::Assets::Middleware do
  include Support::Setup

  let(:app) { stub('app') }
  let(:middleware) { Travis::Assets::Middleware.new(app, root) }

  setup do
    asset 'javascripts/app.js'
  end

  def env_for(path)
    { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path }
  end

  def get(path)
    middleware.call(env_for(path))
  end

  describe 'given a path that does not exist' do
    it 'calls the app' do
      app.expects(:call)
      middleware.call(env_for('/does/not/exist'))
    end
  end

  describe 'given a path that exist' do
    describe 'refers to the current version' do
      before :each do
        Travis::Assets.stubs(:versions).returns([Travis::Assets.version])
      end

      it 'serves the file' do
        path = "/#{Travis::Assets.version}/javascripts/application.js"
        response = get(path)
        response.first.should == 200
        response.last.path.should == "#{root.join('public')}#{path}"
      end
    end

    describe 'refers to an outdated version' do
      before :each do
        Travis::Assets.stubs(:versions).returns(['1234567'])
      end

      it 'redirects to the new version' do
        path = "/#{Travis::Assets.versions.last}/javascripts/application.js"
        response = get(path)
        response.first.should == 301
      end
    end
  end
end
