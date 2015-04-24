require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Tracker

    attr_accessor :config

    attr_accessor :id
    attr_accessor :name

    def initialize(i=nil)
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      if i
        t = TrackerList.new
        @id = t.trackers[i].id
        @name = t.trackers[i].name
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

  class TrackerList
  include ActiveModel::Serializers::JSON
    attr_accessor :config
    attr_accessor :trackers

    def initialize
      @config = Config.instance
      @trackers = []
      raise 'Main Redmine class not configured' unless @config.configured?
      json = @config.connection.get("/trackers.json").body
      list = eval json
      list[:trackers].each do |tracker|
        t = Tracker.new
        t.id = tracker[:id]
        t.name = tracker[:name]
        @trackers[tracker[:id]] = t
      end
    end
  end
end


