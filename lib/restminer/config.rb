module Restminer
  class Config

    attr_accessor :url
    attr_accessor :api_key

    attr_accessor :connection

    def initialize(url,api_key)
      self.url=url
      self.api_key=api_key

      self.connection = Faraday.new(url: url) do |f|
        f.adapter Faraday.default_adapter
      end
      @connection.basic_auth(api_key,api_key)
    end

    class << self
      def from_file(file)
        url = ""
        api_key = ""
        if File.exist?(file)
          File.new("#{ENV['HOME']}/.restminer/config").readlines.each {|line| eval line}
        end
        Config.new(url,api_key)
      end

      def from_default_file
        Config.from_file("#{ENV['HOME']}/.restminer/config")
      end
    end
  end
end
