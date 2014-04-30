module Phishin
  module Api
    class Response
      attr_reader :http_status
      attr_reader :total_entries
      attr_reader :total_pages
      attr_reader :page
      attr_reader :data
      attr_reader :url

      def initialize(url, response_data)
        @url = url
        @success = response_data['success']

        if success?
          @total_entries = response_data['total_entries']
          @total_pages = response_data['total_pages']
          @page = response_data['page']
          @data = response_data['data']
        else
          @message = response_data['message']
          raise Phishin::Client::UnsuccessfulResponseError.new(url, @message)
        end
      end

      def [](key)
        return @data[key]
      end

      def success?
        return @success == true
      end
    end
  end
end
