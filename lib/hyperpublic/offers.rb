module Hyperpublic
  class Offers < Base
    extend Forwardable

    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(params={})
      if params.is_a? String
        perform_get("/offers/#{params}")
      else
        q = Addressable::URI.new
        q.query_values = stringify(params)
        perform_get("/offers?#{q.query}")
      end
    end

    def show(id)
      perform_get("/offers/#{id}")
    end
  end
end
