module Hyperpublic
  class Request
    extend Forwardable

    def self.get(client, path, options={})
      new(client, :get, path, options).perform
    end

    def self.post(client, path, options={})
      new(client, :post, path, options).perform
    end

    def self.post_multi(client, path, options={})
      new(client, :post_multi, path, options).perform
    end

    def self.put(client, path, options={})
      new(client, :put, path, options).perform
    end

    def self.delete(client, path, options={})
      new(client, :delete, path, options).perform
    end

    attr_reader :client, :method, :path, :options

    def_delegators :client, :get, :post, :post_multi, :put, :delete

    def initialize(client, method, path, options={})
      @client, @method, @path, @options = client, method, path, options
    end

    def uri
      @uri ||= begin
        uri = URI.parse(path)

        if options[:query] && options[:query] != {}
          uri.query = to_query(options[:query])
        end

        uri.to_s
      end
    end

    def perform
      Hyperpublic.make_friendly(send("perform_#{method}"))
    end

    private
    def perform_get
      get(uri, options[:headers])
    end

    def perform_post
      post(uri, options[:body], options[:headers])
    end

    def perform_put
      put(uri, options[:body], options[:headers])
    end

    def perform_delete
      delete(uri, options[:headers])
    end

    def to_query(options)
      options.inject([]) do |collection, opt|
        collection << "#{opt[0]}=#{opt[1]}"
        collection
      end * '&'
    end

=begin
    def perform_get
      #get(uri, options || {})
      get(uri)
    end

    def perform_post
      #post(uri, options[:body], options[:headers] || {})
      post(uri, options[:body])
    end

    def perform_post_multi
      post_multi(uri, options[:body], options[:headers] || {})
    end

    def perform_put
      put(uri, options[:body], options[:headers] || {})
    end

    def perform_delete
      delete(uri, options[:headers] || {})
    end

    def to_query(options)
      options.inject([]) do |collection, opt|
        collection << "#{opt[0]}=#{opt[1]}"
        collection
      end * '&'
    end
=end
  end
end

