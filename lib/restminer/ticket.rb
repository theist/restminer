require 'faraday'
require 'json'
require_relative 'config'
require_relative 'user'
require_relative 'tracker'
require_relative 'status'
require_relative 'priority'
require_relative 'project'
require 'active_model'

module Restminer

  class TicketList
  include ActiveModel::Serializers::JSON
    attr_accessor :config
    attr_accessor :ticket_list

    def attributes
      instance_values
    end

    def attributes=(json)
      if json.is_a?(Array)
        json.each do |ticket|
          t = Ticket.new
          t.from_json(ticket.to_json,false)
          @ticket_list.push(t)
        end
      end
    end

    def initialize(filter = nil)
      @ticket_list = []
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      json = @config.connection.get("/issues.json").body
      from_json(json,true)
    end

  end

  class Ticket
  include ActiveModel::Serializers::JSON
    attr_accessor :config

    @new_ticket = true
    def attributes=(hash)
      hash.each do |k,v|
        class_eval { attr_accessor k}
        case k
        when 'priority'
          send("#{k}=", Priority.from_ref(v))
        when 'status'
          send("#{k}=", Status.from_ref(v))
        when 'tracker'
          send("#{k}=", Tracker.from_ref(v))
        when 'project'
          send("#{k}=", Project.from_ref(v))
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


