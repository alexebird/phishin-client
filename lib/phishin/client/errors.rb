module Phishin
  module Client
    class Error < StandardError ; end

    class TrackNotFoundError < StandardError
      def initialize(show_date, track_id_or_slug)
        super("phish.in api could not find track with show_date=#{show_date} track_id_or_slug=#{track_id_or_slug} (possibly the 'missing track' issue)")
      end
    end

    # Raised when there is no response body
    class EmptyResponseError < StandardError
      attr_reader :url

      def initialize(url)
        @url = url
        super("phish.in api response body was empty for url=#{url}")
      end
    end

    class UnsuccessfulResponseError < StandardError
      attr_reader :url

      def initialize(url, message)
        @url = url
        super("phish.in api response body has success=false. message='#{message}'")
      end
    end
  end
end

