module Untied
  module Consumer

  end
end

require 'untied-consumer/event'
require 'untied-consumer/config'
require 'untied-consumer/processor'
require 'untied-consumer/observer'
require 'untied-consumer/railtie' if defined?(Rails)
