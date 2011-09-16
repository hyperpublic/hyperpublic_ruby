module Hyperpublic
  class Categories< Base
    extend Forwardable
    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(params={})
      q = Addressable::URI.new
      q.query_values = stringify(params)
      perform_get("/categories#{("?" + q.query) unless q.query.empty?}")
    end
  end
end

