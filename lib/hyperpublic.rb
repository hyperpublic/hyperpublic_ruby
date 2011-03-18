require "forwardable"
#require "oauth"
require "hashie"
require "httparty"
require "multi_json"
require 'ruby-debug'

module Hyperpublic
  include HTTParty

  class HyperpublicError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end

  class Unauthorized  < HyperpublicError; end
  class General       < HyperpublicError; end

  class BadRequest    < StandardError; end
  class Unavailable   < StandardError; end
  class NotFound      < StandardError; end

  def self.user_agent
    @user_agent ||= 'Ruby Hyperpublic Gem'
  end

  def self.user_agent=(value)
    @user_agent = value
  end

  def self.api_endpoint
    @api_endpoint ||= "localhost:3000/api/v#{self.api_version}"
  end

  def self.api_endpoint=(value)
    @api_endpoint = value
  end

  def self.api_version
    @api_version ||= "1"
  end

  def self.api_version=(value)
    @api_version = value
  end

  private

  def self.perform_get(uri, options = {})
    base_uri self.api_endpoint
    make_friendly(get(uri, options))
  end

  def self.make_friendly(response)
    raise_errors(response)
    data = parse(response)
    # Don't mash arrays of integers
    if data && data.is_a?(Array) && data.first.is_a?(Integer)
      data
    else
      mash(data)
    end
  end

  def self.raise_errors(response)
    case response.code.to_i
      when 400
        data = parse(response)
        raise BadRequest.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 401
        data = parse(response)
        raise Unauthorized.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 403
        data = parse(response)
        raise General.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 404
        raise NotFound, "(#{response.code}): #{response.message}"
      when 502..503
        raise Unavailable, "(#{response.code}): #{response.message}"
    end
  end

  def self.parse(response)
    case response.body
    when ''
      nil
    when 'true'
      true
    when 'false'
      false
    else
      MultiJson.decode(response.body)
    end
  end

  def self.mash(obj)
    if obj.is_a?(Array)
      obj.map{|item| Hashie::Mash.new(item)}
    elsif obj.is_a?(Hash)
      Hashie::Mash.new(obj)
    else
      obj
    end
  end
end

module Hashie
  class Mash

    # Converts all of the keys to strings, optionally formatting key name
    def rubyify_keys!
      keys.each{|k|
        v = delete(k)
        new_key = k.to_s.underscore
        self[new_key] = v
        v.rubyify_keys! if v.is_a?(Hash)
        v.each{|p| p.rubyify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
      }
      self
    end

  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, "hyperpublic", "oauth")
require File.join(directory, "hyperpublic", "auth")
require File.join(directory, "hyperpublic", "request")
require File.join(directory, "hyperpublic", "base")
require File.join(directory, "hyperpublic", "people")
require File.join(directory, "hyperpublic", "things")
require File.join(directory, "hyperpublic", "places")
#require File.join(directory, "hyperpublic", "search")
#require File.join(directory, "hyperpublic", "trends")
#require File.join(directory, "hyperpublic", "geo")

