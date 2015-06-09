require "thor"
require "terminfo"
require "colorize"

COLS = TermInfo.screen_columns

module Restminer
  class QueryCLI < Thor
    desc "list", "list visible queries"
    def list
      r = Redmine.new
      q = QueriesList.new
      q.queries.each do | item |
        if item
          puts "#{item.id} #{item}"
        end
      end
    end
  end

  class TicketCLI < Thor
    desc "Read INT", "reads ticket i"
    def read(id)
      r = Redmine.new
      t = Ticket.new(id)
      puts "-".green * COLS
      puts "[#{t.tracker}]".blue + "[#{t.project}:##{t.id}]".green + "   #{t.subject}".white
      puts "-".green * COLS
      puts "Autor:      ".green + "#{t.author}".red
      puts "Asignado a: ".green + "#{t.assigned_to}".red
      puts "Estado:     ".green + "#{t.status}".red
      puts "Prioridad:  ".green + "#{t.priority}".red
      #puts "Categoria:  ".green + "#{t.category}".red
      puts "-".green * COLS
      puts t.description
      puts "-".green * COLS
      puts "#{r.config.url}/issues/#{t.id}"
      puts "-".green * COLS
    end
  end

  class CLI < Thor
    desc "list", "Ticket listings"
    def list
      r = Redmine.new
      l = TicketList.new
    end
    desc "ticket SUBCOMMAND ... ARGS", "Manage tickets"
    subcommand "ticket", TicketCLI
    desc "query SUBCOMMAND ... ARGS", "Manage queries"
    subcommand "query", QueryCLI
  end
end

