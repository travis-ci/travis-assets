require 'mocha'
require 'travis/assets'
require 'support/setup'

RSpec.configure do |c|
  c.mock_with :mocha

  c.before :each do
    Time.stubs(:now).returns(Time.utc(2012, 5, 1))
  end
end
