require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Project
  include ActiveModel::Serializers::JSON
    attr_accessor :config

    @new_prj = true
    def attributes=(hash)
      hash.each do |k,v|
        class_eval { attr_accessor k}
        send("#{k}=", v)
      end
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
        @new_prj = false
        json = @config.connection.get("/projects/#{id}.json").body
        from_json(json,true)
      end
    end

    class << self
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


