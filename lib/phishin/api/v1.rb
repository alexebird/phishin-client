module Phishin
  module Api
    module V1
      BASE_URL = 'http://phish.in/api/v1'
      HEADERS = { 'accept' => 'application/json' }
      DEFAULT_PARAMS = %i[page per_page sort_attr sort_dir]

      # @param id_or_slug [String,Integer] id or slug belonging to the the resource
      def get_track(id_or_slug)
        check_id_arg('track', id_or_slug)
        perform_get_request('tracks/%s.json' % id_or_slug.to_s)
      end

      # @option opts [Integer] :page The desired page
      # @option opts [Integer] :per_page Results per page
      def get_tracks(opts={})
        perform_get_request('tracks.json', select_params(opts, DEFAULT_PARAMS))
      end



      # @param (see #get_track)
      def get_show(id_or_slug)
        check_id_arg('show', id_or_slug)
        perform_get_request('shows/%s.json' % id_or_slug.to_s)
      end

      # @option (see #get_tracks)
      def get_shows(opts={})
        perform_get_request('shows.json', select_params(opts, DEFAULT_PARAMS))
      end

      # @param show_date [String] a show date in the format YYYY-MM-DD
      def get_show_on_date(show_date)
        raise Phishin::Client::Error, "invalid argument: show_date must match YYYY-MM-DD" unless show_date && show_date =~ /\d{4}-\d{2}-\d{2}/
        perform_get_request('show-on-date/%s.json' % show_date)
      end



      # @param (see #get_track)
      def get_song(id_or_slug)
        check_id_arg('song', id_or_slug)
        perform_get_request('songs/%s.json' % id_or_slug.to_s)
      end

      # @option (see #get_tracks)
      def get_songs(opts={})
        perform_get_request('songs.json', select_params(opts, DEFAULT_PARAMS))
      end



      # @param (see #get_track)
      def get_tour(id_or_slug)
        check_id_arg('tour', id_or_slug)
        perform_get_request('tours/%s.json' % id_or_slug.to_s)
      end

      # @option (see #get_tracks)
      def get_tours(opts={})
        perform_get_request('tours.json', select_params(opts, DEFAULT_PARAMS))
      end



      # @param (see #get_track)
      def get_venue(id_or_slug)
        check_id_arg('venue', id_or_slug)
        perform_get_request('venues/%s.json' % id_or_slug.to_s)
      end

      # @option (see #get_tracks)
      def get_venues(opts={})
        perform_get_request('venues.json', select_params(opts, DEFAULT_PARAMS))
      end



      def get_eras
        perform_get_request('eras.json')
      end

      def get_years
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
        logger.info "phish.in api GET url=#{url} params=#{params}" if logger
        response = RestClient.get(url, HEADERS.merge(params: params))
        resp = Phishin::Api::Response.new(url, Oj.load(response.to_s))
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

