require 'rest_client'

module Hyperpublic
  class Auth
    include HTTParty

    #def_delegators :access_point, :get, :post, :put, :delete

    attr_reader :auth, :api_endpoint

    def initialize(username, password, options={})
      @auth = {:username => username, :password => password}
      @api_endpoint = options[:api_endpoint] || 'http://www.hyperpublic.com/api/v1'
    end

    def get(uri, options={})
      uri = @api_endpoint + uri
      self.class.get(uri, 
        {:query => options, :basic_auth => @auth})
    end

    def post(uri, body, options={})
      uri = @api_endpoint + uri
      self.class.post(uri, {:body => body, :query => options, :basic_auth => @auth})
    end

    def put(uri, body, options={})
      uri = @api_endpoint + uri
      self.class.put(uri, {:body => body, :query => options, :basic_auth => @auth})
    end

    def delete(uri, options={})
      uri = @api_endpoint + uri
      self.class.delete(uri, 
        {:query => options, :basic_auth => @auth})
    end

    def post_multi(uri, body, options={})
      uri = @api_endpoint + uri
      resource = RestClient::Resource.new(uri, :user=>@auth[:username], :password=>@auth[:password])
      resource.post(body)
    end

  end
end
