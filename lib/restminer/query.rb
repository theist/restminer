require 'faraday'
require 'json'
require_relative 'config'
require 'active_model'

module Restminer
  class Query

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
        q = QueryList.new
        self.attributes = q.queries[i].attributes
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

  class QueriesList
  include ActiveModel::Serializers::JSON
    attr_accessor :config
    attr_accessor :queries

    def initialize
      @config = Config.instance
      @queries = []
      raise 'Main Redmine class not configured' unless @config.configured?
      json = @config.connection.get("/queries.json").body
      list = eval json
      list[:queries].each do |query|
        q = Query.new
        q.attributes = query
        @queries[query[:id]] = q
      end
    end
  end
end


