require 'cgi'

module Hyperpublic
  class Base
    extend Forwardable

    def_delegators :client, :get, :post, :post_multi, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def search_neighborhoods(search_string, limit)
      perform_get("/locations/search_neighborhoods", {:search_string => search_string, :limit => limit})
    end

    def search_tags(search_string, limit)
      perform_get("/tags/search", {:search_string => search_string, :limit => limit})
    end

    def photos(params)
      query = {}
      case
        when params[:ids] then query[:ids] = params[:ids]
        when params[:object_id] && params[:object_type] then 
          begin
            query[:object_id] = params[:object_id]
            query[:object_type] = params[:object_type]
          end
      end

      perform_get("/photos", query)
    end

protected

    def self.mime_type(file)
      case
        when file =~ /\.jpg/ then 'image/jpg'
        when file =~ /\.gif$/ then 'image/gif'
        when file =~ /\.png$/ then 'image/png'
        else 'application/octet-stream'
      end
    end

    def mime_type(f) self.class.mime_type(f) end

    CRLF = "\r\n"

    def self.build_multipart_bodies(parts)
      boundary = Time.now.to_i.to_s(16)
      body = ""
      parts.each do |key, value|
        esc_key = CGI.escape(key.to_s)
        body << "--#{boundary}#{CRLF}"
        if value.respond_to?(:read)
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{CRLF}"
          body << "Content-Type: #{mime_type(value.path)}#{CRLF*2}"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{CRLF*2}#{value}"
        end
        body << CRLF
      end
      body << "--#{boundary}--#{CRLF*2}"
      {
        :body => body,
        :headers => {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
      }
    end

    def build_multipart_bodies(parts) self.class.build_multipart_bodies(parts) end


private

    def stringify(obj)
      if obj.is_a? Hash
        obj.each do |key, value|
          obj.delete(key)
          obj[key.to_s] = stringify(value)
        end
      elsif obj.is_a? Array
        obj.collect {|e| stringify(e)}
      else
        obj.to_s
      end
    end

    def tags_str(tags)
      tags_str = (tags.is_a? Array) ? tags.join(",") : tags
      tags_str
    end

    def perform_get(path, options={})
      Hyperpublic::Request.get(self, path, options)
    end

    def perform_post(path, options={})
      Hyperpublic::Request.post(self, path, options)
    end

    def perform_post_multi(path, options={})
      Hyperpublic::Request.post_multi(self, path, options)
    end

    def perform_put(path, options={})
      Hyperpublic::Request.put(self, path, options)
    end

    def perform_delete(path, options={})
      Hyperpublic::Request.delete(self, path, options)
    end
  end
end
