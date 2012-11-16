# -*- encoding : utf-8 -*-

require 'amqp'

module Untied
  module Consumer
    class Worker
      def initialize(opts={})
        @queue_name = opts[:queue_name] || ""
        @consumer = opts[:processor] || Processor.new
      end

      # Initializes the worker and calls the start method
      def self.start(opts={})
        worker = new(opts)
        worker.start
        worker
      end

      # Daemonizes the current worker. Remember you'll need the daemons Gem
      # in order to this method work correctly.
      #
      # Options:
      #   :pids_dir => '/some/dir' Absolute path to the dir where pid files will live
      #   :log_dir => '/some/dir' Absolute path to the dir where log files will live
      #   :pname => 'mylovelydeamom'
      def daemonize(opts={}, &block)
        require 'daemons' # just in case

        pname = opts.delete(:pname) || 'untiedc'
        config = {
          :backtrace  => true,
          :log_output => true,
          :dir_mode   => :normal,
          :dir        => opts[:pids_dir],
          :log_dir    => nil,
        }.merge(opts)

        if !(config[:dir] && config[:log_dir])
          raise ArgumentError.new("You need to provide pids_dir and log_dir")
        end

        FileUtils.mkdir_p(config[:dir])
        FileUtils.mkdir_p(config[:log_dir])

        @worker = self
        @block = block
        Daemons.run_proc(pname, config) do
          @block.call if @block
          @worker.start
        end
      end

      # Listens to the mssage bus for relevant events. This method blocks the
      # current thread.
      def start
        AMQP.start do |connection|
          channel  = AMQP::Channel.new(connection)
          exchange = channel.topic("untied", :auto_delete => true)

          channel.queue(@queue_name, :exclusive => true) do |queue|
            Consumer.config.logger.info "Worker initialized and listening"
            queue.bind(exchange, :routing_key => "untied.#").subscribe do |h,p|
              safe_process { @consumer.process(h,p) }
            end
          end
        end
      end

      protected

      def safe_process(&block)
        begin
          yield
        rescue => e
          if Consumer.config.abort_on_exception
            raise e
          else
            Consumer.config.logger.error e.message
            Consumer.config.logger.error e.backtrace.join("\n\t")
          end
        end
      end
    end
  end
end
