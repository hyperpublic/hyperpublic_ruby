module Hyperpublic
  class Places < Base
    extend Forwardable
    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(params)
      if params.is_a? String
        perform_get("/places/#{params}")
      else
        q = Addressable::URI.new
        q.query_values = stringify(params)
        perform_get("/places?#{q.query}")
      end
    end

    def create(options={})
      perform_post("/places", :body => options)
    end

  end
end
