require 'rest-client'
require 'oj'
require 'hashie'
require 'dalli'

require 'phishin/api'
require 'phishin/api/v1'
require 'phishin/api/response'

require 'phishin/client/version'
require 'phishin/client/cache'
require 'phishin/client/client'
require 'phishin/client/errors'

module Phishin
  module Client

    # Wrapper for {::Phishin::Client::Client#initialize}.
    #
    def new(opts={})
      Phishin::Client::Client.new(opts)
    end
    extend self
  end
end

