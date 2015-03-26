require 'faraday'
require 'json'
require_relative 'config'

module Restminer
  class Redmine
    class << self
      def cli
       get_tickets 
      end

      def get_tickets
        config = Restminer::Config.new
        con = Faraday.new(url: config.url) do |f|
          f.adapter Faraday.default_adapter
        end
        con.basic_auth(config.api_key,config.api_key)
        puts con.get('/issues.json').body
      end
    end
  end
end
