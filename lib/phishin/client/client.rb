module Phishin
  module Client
    class Client

      include Phishin::Api::V1

      DEFAULT_LOGGER = lambda do
        require 'logger'
        logger = Logger.new(STDOUT)
        logger.progname = 'phishin-client'
        formatter = Logger::Formatter.new
        logger.formatter = proc { |severity, datetime, progname, msg|
          formatter.call(severity, datetime, progname, msg)
        }
        logger
      end

      # @param opts [Hash] options hash.
      # @option opts [Boolean] :log Enable/disable logging.
      # @option opts [Object] :logger Logger-compatible object instance to use.
      # @option opts [Boolean] :cache (true) Enable/disable caching.
      # @option opts [Hash] :cache_options options to pass along to the cache.
      #   Leave blank to disable caching.
      def initialize(opts={})
        opts[:log]   = true if !opts.key?(:log)
        cache = opts[:cache] || true
        self.class.logger = opts[:log] ? (opts[:logger] || DEFAULT_LOGGER.call()) : nil

        if cache
          ::Phishin::Client::Cache.setup(opts[:cache_options])
        end
      end

      def logger
        return ::Phishin::Client::Client.logger
      end

      def logger=(logger)
        ::Phishin::Client::Client.logger = logger
      end

      class << self

        @logger = nil

        def logger
          @logger
        end

        def logger=(logger)
          @logger = logger
        end
      end
    end
  end
end

