require 'singleton'

module Restminer
  class Config
    include Singleton

    attr_accessor :url
    attr_accessor :api_key

    attr_accessor :connection

    @configured = false

    def initialize
      self.url= nil
      self.api_key = nil
      self.connection = nil
    end

    def setup(url,api_key)
      self.url=url
      self.api_key=api_key

      self.connection = Faraday.new(url: url) do |f|
        f.adapter Faraday.default_adapter
      end
      @connection.basic_auth(api_key,api_key)
      @configured = true
      return self
    end

    def configured?
      return @configured
    end

    def from_file(file)
      url = ""
      api_key = ""
      if File.exist?(file)
        File.new(file).readlines.each {|line| eval line}
      end
      setup(url,api_key)
    end

    def from_default_file
      from_file("#{ENV['HOME']}/.restminer/config")
    end
  end
end
