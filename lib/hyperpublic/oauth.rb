require 'addressable/uri'
require 'oauth'
require 'oauth/consumer'
require 'json'

module Hyperpublic
  class OAuth
    extend Forwardable

    attr_reader :ctoken, :csecret

    def initialize(ctoken, csecret, options={})
      @ctoken, @csecret, @consumer_options = ctoken, csecret, {}
      @api_endpoint = options[:api_endpoint] || 'https://api.hyperpublic.com/api/v1'
      @consumer = ::OAuth::Consumer.new(ctoken, csecret, :site => @api_endpiont)
      @token = ::OAuth::AccessToken.new(@consumer)
      @signing_endpoint = options[:signing_endpoint] || 'https://api.hyperpublic.com/api/v1'
      if options[:sign_in]
        @consumer_options[:authorize_path] =  '/oauth/authenticate'
      end
      @auth_params = "client_id=#{@ctoken}&client_secret=#{@csecret}" + (@token.token.empty? ? "" : "&access_token=#{@token.token}")
      @auth_params_hash = {"client_id" => @ctoken, "client_secret" => @csecret}
      @auth_params_hash["access_token"] = @token.token unless @token.token.empty?
    end

    def get(uri, options={})
      path = @api_endpoint + uri
      sep = (path =~ /\/.*\?/) ? "&" : "?"
      @token.get(path + sep + @auth_params)
    end

    def post(uri, body, options={})
      body.merge!("client_id" => @ctoken, "client_secret" => @csecret)
      @token.post(@api_endpoint + uri, body.to_json, {"Content-Type" => 'application/json'})
    end

    def put(uri, body, options={})
      @token.put(@api_endpoint + uri, body.merge(@auth_params_hash).to_json, {'Content-Type' => 'application/json'})
    end

    def delete(uri, options={})
      path = @api_endpoint + uri
      sep = (path =~ /\/.*\?/) ? "&" : "?"
      @token.delete(path + sep + @auth_params)
    end

    def access_token
      @access_token ||= ::OAuth::AccessToken.new(signing_consumer, @atoken, @asecret)
    end

    def authorize_from_access(atoken, asecret)
      @atoken, @asecret = atoken, asecret
    end

    private

    def clear_request_token
      @request_token = nil
    end

  end
end

