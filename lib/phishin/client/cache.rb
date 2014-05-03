module Phishin
  module Client
    class Cache
      class << self

        @enabled = nil
        @underlying_cache = nil

        # @api private
        def setup(servers, options)
          expires_in = options[:expires_in] || nil
          @enabled = true
          @underlying_cache = Dalli::Client.new(servers, namespace: 'phishin-client', expires_in: expires_in)
        end

        def enable
          @enabled = true
        end

        def disable
          @enabled = false
        end

        def read(key)
          return nil unless @enabled
          val = @underlying_cache.get(key)
          ::Phishin::Client::Client.logger.info "phish.in cache read" if ::Phishin::Client::Client.logger && val
          return val
        end

        def write(key, value, ttl=nil)
          return unless @enabled
          ::Phishin::Client::Client.logger.info "phish.in cache write" if ::Phishin::Client::Client.logger
          @underlying_cache.set(key, value, ttl)
        end

        def delete(key)
          return nil unless @enabled
          val = @underlying_cache.delete(key)
          ::Phishin::Client::Client.logger.info "phish.in cache delete" if ::Phishin::Client::Client.logger && val
          return val
        end

        def fetch(key, ttl=nil)
          value = read(key)
          if !value
            value = yield
            write(key, value, ttl)
          end
          return value
        end
      end
    end
  end
end

