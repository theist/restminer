module Restminer
  class Config
    attr_accessor :url
    attr_accessor :api_key
    def initialize
      if File.exist?("#{ENV['HOME']}/.restminer/config")
        File.new("#{ENV['HOME']}/.restminer/config").readlines.each {|line| puts line; eval line}
      end
      puts "URL #{url}"
      puts "api_key #{api_key}"
      self.url=url
      self.api_key=api_key
    end
  end
end
