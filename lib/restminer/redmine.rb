require 'faraday'
require 'json'
require_relative 'config'

module Restminer
  class Redmine

    attr_accessor :config

    def initialize
      @config = Config.instance.from_default_file
    end

    def get_tickets
      puts @config.connection.get('/issues.json').body
    end
  end
end




