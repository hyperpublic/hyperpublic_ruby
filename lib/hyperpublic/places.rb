module Hyperpublic
  class Places < Base
    extend Forwardable
    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def find(params)
      if params.is_a? Integer
        perform_get("/places/#{params}")
      else
        q = Addressable::URI.new
        q.query_values = params 
        perform_get("/places?#{q.query}")
      end
    end

    def create(options={})
      raise Exception "this doesn't work yet!" if options[:image]
      perform_post("/places", :body => options)
    end

    def locations(id, options={})
      perform_get("/places/#{id}/locations")
    end

    def addresses(id, options={})
      perform_get("/places/#{id}/addresses")
    end

    def zipcodes(id, options={})
      perform_get("/places/#{id}/zipcodes")
    end

    def neighborhoods(id, options={})
      perform_get("/places/#{id}/neighborhoods")
    end

    def pindrops(id, options={})
      perform_get("/places/#{id}/pindrops")
    end

    def address_create(id, options={})
      perform_post("/places/#{id}/addresses", :body => options)
    end

    def zipcode_create(id, options={})
      perform_post("/places/#{id}/zipcodes", :body => options)
    end

    def neighborhood_create(id, options={})
      perform_post("/places/#{id}/neighborhoods", :body => options)
    end

    def pindrop_create(id, options={})
      perform_post("/places/#{id}/pindrops", :body => options)
    end

    def tags(id)
      perform_get("/places/#{id}/tags")
    end

    def tags_create(id, tags)
      perform_post("/places/#{id}/tags", :body => {:tag_list => tags})
    end

    def tags_update(id, tags)
      perform_put("/places/#{id}/tags", :body => {:tag_list => tags})
    end

    def photos(id)
      perform_get("places/#{id}/photo")
    end
  end
end
