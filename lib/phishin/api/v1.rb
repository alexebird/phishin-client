module Phishin
  module Api
    module V1
      BASE_URL = 'http://phish.in/api/v1'
      HEADERS = { 'accept' => 'application/json' }
      DEFAULT_PARAMS = %i[page per_page sort_attr sort_dir]

      # Get track by id.
      #
      # @param id [Integer] id belonging to the the resource
      def track(id)
        check_id_arg('track', id)
        perform_get_request('tracks/%d.json' % id)
      end

      # Get many tracks.
      #
      # @option opts [Integer] :page The desired page
      # @option opts [Integer] :per_page Results per page
      def tracks(opts={})
        perform_get_request('tracks.json', select_params(opts, DEFAULT_PARAMS))
      end


      # Get show by id or slug (ie, date).
      #
      # @param id_or_slug [Integer] id or slug belonging to the the resource
      def show(id_or_slug)
        check_id_arg('show', id_or_slug)
        perform_get_request('shows/%s.json' % id_or_slug.to_s)
      end

      # Get many shows.
      #
      # @option (see #tracks)
      def shows(opts={})
        perform_get_request('shows.json', select_params(opts, DEFAULT_PARAMS))
      end

      # Get show by date (YYYY-MM-DD).
      #
      # @param show_date [String] a show date in the format YYYY-MM-DD
      # @raise [Phishin::Cilent::Error] if the date format is wrong
      def show_on_date(show_date)
        raise Phishin::Client::Error, "invalid argument: show_date must match YYYY-MM-DD" unless show_date && show_date =~ /\d{4}-\d{2}-\d{2}/
        perform_get_request('show-on-date/%s.json' % show_date)
      end



      # Get song by id or slug.
      #
      # @param (see #show)
      def song(id_or_slug)
        check_id_arg('song', id_or_slug)
        perform_get_request('songs/%s.json' % id_or_slug.to_s)
      end

      # Get many songs
      #
      # @option (see #tracks)
      def songs(opts={})
        perform_get_request('songs.json', select_params(opts, DEFAULT_PARAMS))
      end



      # Get tour by id or slug.
      #
      # @param (see #show)
      def tour(id_or_slug)
        check_id_arg('tour', id_or_slug)
        perform_get_request('tours/%s.json' % id_or_slug.to_s)
      end

      # Get many tours.
      #
      # @option (see #tracks)
      def tours(opts={})
        perform_get_request('tours.json', select_params(opts, DEFAULT_PARAMS))
      end



      # Get venue by id or slug.
      #
      # @param (see #show)
      def venue(id_or_slug)
        check_id_arg('venue', id_or_slug)
        perform_get_request('venues/%s.json' % id_or_slug.to_s)
      end

      # Get many venues.
      #
      # @option (see #tracks)
      def venues(opts={})
        perform_get_request('venues.json', select_params(opts, DEFAULT_PARAMS))
      end



      # Get eras.
      def eras
        perform_get_request('eras.json')
      end

      # Get years.
      def years
        perform_get_request('years.json')
      end



      # @api private
      def select_params(opts, keys)
        params = {}
        keys.each do |key|
          params[key] = opts[key] if opts.key?(key)
        end
        return params
      end

      # @api private
      def assert_response_data_field(response)
        raise Phishin::Client::EmptyResponseError.new(response.url) if !response.data
      end

      # @api private
      def perform_get_request(path, params={})
        url = [BASE_URL, path].join("/")

        key = [url, [params.to_a.sort.map{|e| e.join('=')}].join('&')].join('?')

        json_str = ::Phishin::Client::Cache.fetch(key) do
          logger.info "phish.in api GET url=#{url} params=#{params}" if logger
          RestClient.get(url, HEADERS.merge(params: params)).to_s
        end

        resp = Phishin::Api::Response.new(url, Oj.load(json_str))
        assert_response_data_field(resp)
        return resp
      end

      # @api private
      def check_id_arg(resource_name, val)
        raise Phishin::Client::Error, "invalid argument: must pass #{resource_name} id or slug" unless val
      end
    end
  end
end

