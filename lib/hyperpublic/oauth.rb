require 'addressable/uri'
require 'oauth'
require 'oauth/consumer'
require 'ruby-debug'

module Hyperpublic
  class OAuth
    extend Forwardable

    #def_delegators :access_token, :get, :post, :put, :delete

    #attr_reader :ctoken, :csecret, :consumer_options, :api_endpoint, :signing_endpoint

    # Options
    #   :sign_in => true to just sign in with hyperpublic instead of doing oauth authorization
    def initialize(ctoken, csecret, options={})
      @ctoken, @csecret, @consumer_options = ctoken, csecret, {}
      @api_endpoint = options[:api_endpoint] || 'http://www.hyperpublic.com/api/v1'
      @consumer = ::OAuth::Consumer.new(ctoken, csecret, :site => @api_endpiont)
      @token = ::OAuth::AccessToken.new(@consumer)
      @signing_endpoint = options[:signing_endpoint] || 'http://www.hyperpublic.com/api/v1'
      if options[:sign_in]
        @consumer_options[:authorize_path] =  '/oauth/authenticate'
      end
      @auth_params = "client_id=#{@ctoken}&client_secret=#{@csecret}" + (@token.token.empty? ? "" : "&access_token=#{@token.token}")

    end

    def get(uri, options={})
      path = @api_endpoint + uri
      sep = (path =~ /\/.*\?/) ? "&" : "?"
      @token.get(path + sep + @auth_params)
    end

    def post(uri, body, options={})
      @token.post(@api_endpoint + uri, body.merge("client_id" => @ctoken, "client_secret" => @csecret), {"Content-Type" => 'application/json'})
    end

    def put(uri, body, options={})
      #for now, convert the body into the query parameter
      q = Addressable::URI.new
      q.query_values = body.merge("client_id" => @ctoken, "client_secret" => @csecret)
      @token.put(@api_endpoint + uri + "?" + q.query,{})
    end

    def delete(uri, options={})
      path = @api_endpoint + uri
      sep = (path =~ /\/.*\?/) ? "&" : "?"
      @token.delete(path + sep + @auth_params)
    end

=begin
    def consumer
      @consumer ||= OAuth::Consumer.new(@ctoken, @csecret, {:site => @api_endpoint})
    end

    def signing_consumer
      @signing_consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => signing_endpoint, :request_endpoint => api_endpoint }.merge(consumer_options))
    end

    def set_callback_url(url)
      clear_request_token
      request_token(:oauth_callback => url)
    end

    # Note: If using oauth with a web app, be sure to provide :oauth_callback.
    # Options:
    #   :oauth_callback => String, url that hyperpublic should redirect to
    def request_token(options={})
      @request_token ||= signing_consumer.get_request_token(options)
    end

    # For web apps use params[:oauth_verifier], for desktop apps,
    # use the verifier that is the pin that hyperpublic gives users.
    def authorize_from_request(rtoken, rsecret, verifier_or_pin)
      request_token = ::OAuth::RequestToken.new(signing_consumer, rtoken, rsecret)
      access_token = request_token.get_access_token(:oauth_verifier => verifier_or_pin)
      @atoken, @asecret = access_token.token, access_token.secret
    end

=end
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

