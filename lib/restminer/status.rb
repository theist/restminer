require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Status

    attr_accessor :config

    def attributes=(hash)
      hash.each do |k,v|
        class_eval { attr_accessor k}
        send("#{k}=", v)
      end
    end

    def attributes
      instance_values
    end

    def initialize(i=nil)
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      if i
        s = StatusList.new
        self.attributes = s.statuses[i].attributes
      end
    end

    def to_s
      return name
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

  class StatusList
  include ActiveModel::Serializers::JSON
    attr_accessor :config
    attr_accessor :statuses

    def initialize
      @config = Config.instance
      @statuses = []
      raise 'Main Redmine class not configured' unless @config.configured?
      json = @config.connection.get("/issue_statuses.json").body
      list = eval json
      list[:issue_statuses].each do |status|
        s = Status.new
        s.attributes = status
        @statuses[status[:id]] = s
      end
    end
  end
end


