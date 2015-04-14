require 'faraday'
require 'json'
require_relative 'config'

module Restminer
  class Ticket

    attr_accessor :config
    @new_ticket = true

    def initialize(id = nil)
      @config = Config.instance
      raise 'Main Redmine class not configured' unless @config.configured?
      if id
        @new_ticket = false
        puts @config.connection.get("/issues/#{id}.json").body
      end
    end
  end
end




