require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class User
  include ActiveModel::Serializers::JSON
    attr_accessor :config

    @new_user = true
    def attributes=(hash)
      hash.each do |k,v|
        class_eval { attr_accessor k}
        send("#{k}=", v)
      end
    end

    def name
      return firstname + ' ' + lastname
    end

    def attributes
      instance_values
    end

    def to_s
      return name
    end

    def initialize(id = nil)
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      if id
        @new_user = false
        json = @config.connection.get("/users/#{id}.json").body
        from_json(json,true)
      end
    end

    class << self
      def me
        a = new
        json = a.config.connection.get("/users/current.json").body
        a.from_json(json,true)
        return a
      end

      def from_ref(ref)
        if ref['id'] then
          return new(ref['id'])
        else
          return nil
        end
      end
    end
  end
end


