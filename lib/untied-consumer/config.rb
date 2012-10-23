# -*- encoding : utf-8 -*-
require 'configurable'
require 'logger'

module Untied
  module Consumer
    def self.configure(&block)
      yield(config) if block_given?
      Processor.observers = config.observers
    end

    def self.config
      @config ||= Config.new
    end

    class Config
      include Configurable

      config :logger, Logger.new(STDOUT)
      config :observers, []
      config :abort_on_exception, false
    end
  end
end


