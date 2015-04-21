require 'faraday'
require 'json'
require_relative 'config'
require_relative 'user'
require 'active_model'

module Restminer
  class Ticket
  include ActiveModel::Serializers::JSON
    attr_accessor :config

    @new_ticket = true
    def attributes=(hash)
      hash.each do |k,v|
        class_eval { attr_accessor k}
        case k
        when 'author'
          send("#{k}=", User.from_ref(v))
        when 'assigned_to'
          send("#{k}=", User.from_ref(v))
        else
          send("#{k}=", v)
        end
      end
    end

    def attributes
      instance_values
    end

    def to_s
      return "[Ticket:#{id}] #{subject}"
    end

    def initialize(id = nil)
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      if id
        @new_ticket = false
        json = @config.connection.get("/issues/#{id}.json").body
        from_json(json,true)
      end
    end
  end
end


