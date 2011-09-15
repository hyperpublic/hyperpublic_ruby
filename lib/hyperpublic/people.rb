module Hyperpublic
  class People < Base
    extend Forwardable
    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    #param can be 
    #   id
    #   {:ids => [1, 2, 3]}, 
    #   {:tags => [tag1, tags]}, or 
    #   {:location => {:lat=>35,:lon=>-70}}
    #   etc
    def find(params)
      if params.is_a? String
        perform_get("/people/#{params}")
      else
        q = Addressable::URI.new
        q.query_values = stringify(params)
        perform_get("/people?#{q.query}")
      end
    end

    def create(options={})
      perform_post("/people", :body => options)
    end
  end
end
