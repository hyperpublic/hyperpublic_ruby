#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#$LOAD_PATH.unshift(File.dirname(__FILE__))

require "pathname"
#require "shoulda"
#require "mocha"
require 'fakeweb'
require 'hyperpublic'

FakeWeb.allow_net_connect = false

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

end

def hyperpublic_url(auth, url)
  if auth.auth[:username] && auth.auth[:password]
    url =~ /^http/ ? url : "http://#{auth.auth[:username]}:#{auth.auth[:password]}@www.hyperpublic.com/api/v1/#{url}" 
  else
    url =~ /^http/ ? url : "http://www.hyperpublic.com/api/v1/#{url}"
  end
end

def stub_get(auth, url, result, status=nil)
  test = hyperpublic_url(auth, url)
  options = {:body => result}
  options.merge!({:status => status}) unless status.nil?
  FakeWeb.register_uri(:get, hyperpublic_url(auth, url), options)
end

def stub_post(auth, url, result)
  FakeWeb.register_uri(:post, hyperpublic_url(auth, url), :body => result)
end

def stub_put(auth, url, result)
  FakeWeb.register_uri(:put, hyperpublic_url(auth, url), :body => result)
end

def stub_delete(auth, url, result)
  FakeWeb.register_uri(:delete, hyperpublic_url(auth, url), :body => result)
end

