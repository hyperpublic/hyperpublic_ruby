module Hyperpublic
  class Things < Base
    extend Forwardable
    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(params)
      if params.is_a? String
        perform_get("/things/#{params}")
      else
        q = Addressable::URI.new
        q.query_values = stringify(params)
        perform_get("/things?#{q.query}")
      end
    end

    def create(options={})
      perform_post("/things", :body => options)
    end

  end
end
