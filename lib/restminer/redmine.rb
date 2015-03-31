require 'faraday'
require 'json'
require_relative 'config'

module Restminer
  class Redmine

    attr_accessor :config

    def initialize
      @config = Config.from_default_file
    end

    def get_tickets
      puts @config.connection.get('/issues.json').body
    end

    class << self
      def cli
        r = Redmine.new
        r.get_tickets
      end
    end
  end
end




