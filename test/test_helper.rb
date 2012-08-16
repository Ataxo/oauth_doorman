
require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'turn'

# require 'fakeweb'
# require 'mocha'

# instead requiring installed gem, always test his latest version
require File.join(File.dirname(__FILE__), '..', 'lib', 'oauth_doorman')

class Test::Unit::TestCase

  # don't allow internet connections for testing by default
  # FakeWeb.allow_net_connect = false

  # helper method for loading fixtures
  def read_fixture(filename, extension = 'xml')
    # add extension to file unless it already has it
    filename += ".#{extension}" unless (filename =~ /\.\w+$/)
    
    File.read File.expand_path(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end

  # general setup, can be overriden or extended in specific tests
  def setup; end

end
