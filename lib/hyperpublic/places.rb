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

    def search(params)
      q = Addressable::URI.new
      q.query_values = stringify(params)
      perform_get("/places/search?#{q.query}")
    end

    def create(options={})
      raise Exception "this doesn't work yet!" if options[:image]
      options[:q] = arr_str(options[:q]) if options[:q].is_a? Array
      perform_post("/places", :body => options)
    end

    def locations(id, options={})
      perform_get("/places/#{id}/locations")
    end

    def location_create(id, options={})
      perform_post("/places/#{id}/locations", :body => options)
    end

    def tags(id)
      perform_get("/places/#{id}/tags")
    end

    def tags_create(id, tags)
      perform_post("/places/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

    def tags_update(id, tags)
      perform_put("/places/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

    def photos(id)
      perform_get("places/#{id}/photo")
    end

  end
end
