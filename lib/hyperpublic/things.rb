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

    def search(params)
      q = Addressable::URI.new
      q.query_values = stringify(params)
      perform_get("/things/search?#{q.query}")
    end


    def create(options={})
      raise Exception "this doesn't work yet!" if options[:image]
      options[:tags] = arr_str(options[:tags]) if options[:tags].is_a? Array
      perform_post("/things", :body => options)
    end

    def locations(id, options={})
      perform_get("/things/#{id}/locations")
    end

    def location_create(id, options={})
      perform_post("/things/#{id}/locations", :body => options)
    end

    def tags(id)
      perform_get("/things/#{id}/tags")
    end

    def tags_create(id, tags)
      perform_post("/things/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

    def tags_update(id, tags)
      perform_put("/things/#{id}/tags", :body => {:tags => arr_str(tags)})
    end

  end
end
