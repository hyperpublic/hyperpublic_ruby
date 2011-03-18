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
      if params.is_a? Integer
        perform_get("/people/#{params}")
      else
        query = {}
        if (params[:ids])
          query[:ids] = params[:ids]
        elsif (params[:email])
          query[:email] = params[:email]
        elsif (params[:name])
          query[:name] = params[:name]
        elsif (params[:location])
          query[:location] = params[:location]
        elsif (params[:tags])
          query[:tags] = params[:tags]
        end

        q = Addressable::URI.new
        q.query_values = query
        perform_get("/people?#{q.query}")
      end
    end

    def create(options={})
      raise Exception "this doesn't work yet!" if options[:image]
      perform_post("/people", :body => options)
    end

    def locations(id, options={})
      perform_get("/people/#{id}/locations")
    end

    def addresses(id, options={})
      perform_get("/people/#{id}/addresses")
    end

    def zipcodes(id, options={})
      perform_get("/people/#{id}/zipcodes")
    end

    def neighborhoods(id, options={})
      perform_get("/people/#{id}/neighborhoods")
    end

    def pindrops(id, options={})
      perform_get("/people/#{id}/pindrops")
    end

    def address_create(id, options={})
      perform_post("/people/#{id}/addresses", :body => options)
    end

    def zipcode_create(id, options={})
      perform_post("/people/#{id}/zipcodes", :body => options)
    end

    def neighborhood_create(id, options={})
      perform_post("/people/#{id}/neighborhoods", :body => options)
    end

    def pindrop_create(id, options={})
      perform_post("/people/#{id}/pindrops", :body => options)
    end

    def tags(id)
      perform_get("/people/#{id}/tags")
    end

    def tags_create(id, tags)
      perform_post("/people/#{id}/tags", :body => {:tag_list => tags})
    end

    def tags_update(id, tags)
      perform_put("/people/#{id}/tags", :body => {:tag_list => tags})
    end
  end
end
