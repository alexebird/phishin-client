module Phishin
  module Client
    class Client

      include Phishin::Api::V1

      attr_accessor :logger

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
        @logger = opts[:log] ? (opts[:logger] || DEFAULT_LOGGER.call()) : nil
      end
    end
  end
end

