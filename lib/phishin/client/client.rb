module Phishin
  module Client
    class Client

      include Phishin::Api::V1

      DEFAULT_LOGGER = lambda do
        require 'logger'
        logger = Logger.new(STDOUT)
        logger.progname = 'phishin-client'
        logger
      end

      # @option opts [Boolean] :log Enable/disable logging
      # @option opts [Object] :logger Logger-compatible object instance to use
      def initialize(opts={})
        opts[:log] = true if !opts.key?(:log)
        self.class.logger = opts[:log] ? (opts[:logger] || DEFAULT_LOGGER.call()) : nil

        ::Phishin::Client::Cache.setup(['localhost:11211'], expires_in: 3600)
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

