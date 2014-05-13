module Phishin
  module Client
    class Cache

      CACHE_NAMESPACE = 'phishin-client'

      class << self

        @enabled = nil
        @underlying_cache = nil

        # @api private
        def setup(opts={})
          @enabled = true

          #require 'dalli'
          #@underlying_cache = MemcachedCache.new(opts)
          require 'redis'
          @underlying_cache = RedisCache.new(opts)
        end

        # @api private
        def should_cache?
          return @enabled && !!@underlying_cache
        end

        def enable
          @enabled = true
        end

        def disable
          @enabled = false
        end

        def read(key)
          return nil unless should_cache?

          val = @underlying_cache.get(key)
          log_cache_action('read', key, val) if val
          return val
        end

        def write(key, value, ttl=nil)
          return nil unless should_cache?

          log_cache_action('write', key, value)
          @underlying_cache.set(key, value, ttl)
        end

        def delete(key)
          return nil unless should_cache?

          val = @underlying_cache.delete(key)
          log_cache_action('delete', key) if val
          return val
        end

        # @api private
        def log_cache_action(action, key, val=nil)
          ::Phishin::Client::Client.logger.info "phish.in cache #{action} key=#{key[0..8]}" if ::Phishin::Client::Client.logger
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

    class RedisCache
      def initialize(opts={})
        @expires_in = opts[:expires_in] || nil
        @client = Redis.new
      end

      def get(key)
        @client.get(namespace_key(key))
      end

      def set(key, value, ttl=nil)
        ttl ||= @expires_in
        @client.set(namespace_key(key), value, { ex: ttl })
      end

      def delete(key)
        @client.del(namespace_key(key))
      end

      private

      def namespace_key(key)
        format('%s:%s', Cache::CACHE_NAMESPACE, key)
      end
    end

    class MemcachedCache
      def initialize(opts={})
        expires_in = opts[:expires_in] || nil
        servers    = opts[:servers]
        @client = Dalli::Client.new(servers, namespace: Cache::CACHE_NAMESPACE, expires_in: expires_in)
      end

      def get(key)
      end

      def set(key, value, ttl=nil)
        @client.set(key, value, ttl)
      end

      def delete(key)
      end
    end
  end
end

