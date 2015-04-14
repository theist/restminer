require "thor"

module Restminer
  class CLI < Thor
    desc "list", "Ticket listings"
    def list
      r = Redmine.new
      r.get_tickets
    end
  end
end

