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
      raise Exception "this doesn't work yet!" if options[:image]
      options[:tags] = arr_str(options[:tags]) if options[:tags].is_a? Array
      perform_post("/things", :body => options)
    end

    def locations(id, options={})
      perform_get("/things/#{id}/locations")
    end

    def addresses(id, options={})
      perform_get("/things/#{id}/addresses")
    end

    def zipcodes(id, options={})
      perform_get("/things/#{id}/zipcodes")
    end

    def neighborhoods(id, options={})
      perform_get("/things/#{id}/neighborhoods")
    end

    def pindrops(id, options={})
      perform_get("/things/#{id}/pindrops")
    end

    def address_create(id, options={})
      perform_post("/things/#{id}/addresses", :body => options)
    end

    def zipcode_create(id, options={})
      perform_post("/things/#{id}/zipcodes", :body => options)
    end

    def neighborhood_create(id, options={})
      perform_post("/things/#{id}/neighborhoods", :body => options)
    end

    def pindrop_create(id, options={})
      perform_post("/things/#{id}/pindrops", :body => options)
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
