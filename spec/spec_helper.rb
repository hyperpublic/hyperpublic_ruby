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

def hyperpublic_url(auth, url, req)
  url =~ /^http/ ? url : "https://api.hyperpublic.com/api/v1/#{(url[-1,1] == "?" || req != "get") ? url : url+'&' }" + ((req == "get") ? "client_id=#{auth.ctoken}&client_secret=#{auth.csecret}" : "")
end

def stub_get(auth, url, result, status=nil)
  options = {:body => result}
  options.merge!({:status => status}) unless status.nil?
  FakeWeb.register_uri(:get, hyperpublic_url(auth, url, "get"), options)
end

def stub_post(auth, url, result)
  FakeWeb.register_uri(:post, hyperpublic_url(auth, url, "post"), :body => result)
end

def stub_put(auth, url, result)
  FakeWeb.register_uri(:put, hyperpublic_url(auth, url, "put"), :body => result)
end

def stub_delete(auth, url, result)
  FakeWeb.register_uri(:delete, hyperpublic_url(auth, url, "delete"), :body => result)
end

