module Restminer
  class Config

    attr_accessor :url
    attr_accessor :api_key

    def initialize(url,api_key)
      puts "URL #{url}"
      puts "api_key #{api_key}"
      self.url=url
      self.api_key=api_key
    end

    class << self
      def from_file(file)
        url = ""
        api_key = ""
        if File.exist?(file)
          File.new("#{ENV['HOME']}/.restminer/config").readlines.each {|line| puts line; eval line}
        end
        Config.new(url,api_key)
      end

      def from_default_file
        Config.from_file("#{ENV['HOME']}/.restminer/config")
      end
    end
  end
end
