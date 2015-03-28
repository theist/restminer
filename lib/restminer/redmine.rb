require 'faraday'
require 'json'
require_relative 'config'

module Restminer
  class Redmine

    attr_accessor :config
    attr_accessor :connection

    def initialize
      @config = Config.from_default_file
      @connection=Faraday.new(url: config.url) do |f|
        f.adapter Faraday.default_adapter
      end
      @connection.basic_auth(config.api_key, config.api_key)
    end

    def get_tickets
      puts @connection.get('/issues.json').body
    end

    class << self
      def cli
        r = Redmine.new
        r.get_tickets
      end
    end
  end
end




