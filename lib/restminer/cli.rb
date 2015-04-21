require "thor"
require "terminfo"
require "colorize"

COLS = TermInfo.screen_columns

module Restminer
  class TicketCLI < Thor
    desc "Read INT", "reads ticket i"
    def read(id)
      r = Redmine.new
      t = Ticket.new(id)
    end
  end

  class CLI < Thor
    desc "list", "Ticket listings"
    def list
      r = Redmine.new
      r.get_tickets
    end
    desc "ticket SUBCOMMAND ... ARGS", "Manage tickets"
    subcommand "ticket", TicketCLI
  end
end

