require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Ticket
  include ActiveModel::Serializers::JSON
    attr_accessor :config

    attr_accessor :id, :project, :tracker, :status, :priority,
                  :author, :assigned_to, :fixed_version, :subject,
                  :description, :start_date, :done_ratio, :spent_hours,
                  :created_on, :updated_on, :closed_on

    @new_ticket = true
    def attributes=(hash)
      hash.each do |k,v|
        send("#{k}=", v)
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


