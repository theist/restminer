require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Priority

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
        p = PrioritiesList.new
        self.attributes = p.priorities[i].attributes
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

  class PrioritiesList
  include ActiveModel::Serializers::JSON
    attr_accessor :config
    attr_accessor :priorities

    def initialize
      @config = Config.instance
      @priorities = []
      raise 'Main Redmine class not configured' unless @config.configured?
      json = @config.connection.get("/enumerations/issue_priorities.json").body
      list = eval json
      list[:issue_priorities].each do |priority|
        p = Priority.new
        p.attributes = priority
        @priorities[priority[:id]] = p
      end
    end
  end
end

