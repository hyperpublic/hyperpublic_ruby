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
      raise Exception "this doesn't work yet!" if options[:image]
      options[:q] = arr_str(options[:q]) if options[:q].is_a? Array
      perform_post("/people", :body => options)
    end

    def locations(id, options={})
      perform_get("/people/#{id}/locations")
    end

    def location_create(id, options={})
      perform_post("/people/#{id}/locations", :body => options)
    end

    def tags(id)
      perform_get("/people/#{id}/tags")
    end

    def tags_create(id, tags)
      perform_post("/people/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

    def tags_update(id, tags)
      perform_put("/people/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

  end
end
