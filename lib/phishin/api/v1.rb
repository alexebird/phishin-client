module Phishin
  module Api
    module V1
      BASE_URL = 'http://phish.in/api/v1'
      HEADERS = { 'accept' => 'application/json' }

      # Get track by id.
      #
      # @param id [Integer] id belonging to the the resource
      # @option opts [Boolean] :force (false) no caching for this request
      def track(id, opts={})
        check_id_arg('track', id)
        perform_get_request(format('tracks/%d.json', id), nil, opts)
      end

      # Get many tracks.
      #
      # For more on available params, see http://phish.in/api-docs.
      #
      # @option opts (see #track)
      # @option opts [Hash] :params parameters for HTTP GET query string
      #   - :page (Integer) The desired page
      #   - :per_page (Integer) Results per page
      #   - :sort_attr (String) Sorting attribute
      #   - :sort_dir  (String) Sorting direction (ASC|DESC)
      def tracks(opts={})
        perform_get_request('tracks.json', opts)
      end


      # Get show by id or slug (ie, date).
      #
      # @param id_or_slug [Integer] id or slug belonging to the the resource
      # @option opts (see #track)
      def show(id_or_slug, opts={})
        check_id_arg('show', id_or_slug)
        perform_get_request(format('shows/%s.json', id_or_slug.to_s), opts)
      end

      # Get many shows.
      #
      # @option opts (see #tracks)
      def shows(opts={})
        perform_get_request('shows.json', opts)
      end

      # Get show by date (YYYY-MM-DD).
      #
      # @param show_date [String] a show date in the format YYYY-MM-DD
      # @option opts (see #track)
      # @raise [Phishin::Cilent::Error] if the date format is wrong
      def show_on_date(show_date, opts={})
        raise Phishin::Client::Error, "invalid argument: show_date must match YYYY-MM-DD" unless show_date && show_date =~ /\d{4}-\d{2}-\d{2}/
        perform_get_request(format('show-on-date/%s.json', show_date), opts)
      end



      # Get song by id or slug.
      #
      # @param id_or_slug (see #show)
      # @option opts (see #track)
      def song(id_or_slug, opts={})
        check_id_arg('song', id_or_slug)
        perform_get_request(format('songs/%s.json', id_or_slug.to_s), opts)
      end

      # Get many songs
      #
      # @option opts (see #tracks)
      def songs(opts={})
        perform_get_request('songs.json', opts)
      end



      # Get tour by id or slug.
      #
      # @param id_or_slug (see #show)
      # @option opts (see #track)
      def tour(id_or_slug, opts={})
        check_id_arg('tour', id_or_slug)
        perform_get_request(format('tours/%s.json', id_or_slug.to_s), opts)
      end

      # Get many tours.
      #
      # @option opts (see #tracks)
      def tours(opts={})
        perform_get_request('tours.json', opts)
      end



      # Get venue by id or slug.
      #
      # @param id_or_slug (see #show)
      # @option opts (see #track)
      def venue(id_or_slug, opts={})
        check_id_arg('venue', id_or_slug)
        perform_get_request(format('venues/%s.json', id_or_slug.to_s), opts)
      end

      # Get many venues.
      #
      # @option opts (see #tracks)
      def venues(opts={})
        perform_get_request('venues.json', opts)
      end



      # Get eras.
      #
      # @option opts (see #track)
      def eras(opts={})
        perform_get_request('eras.json', opts)
      end

      # Get years.
      #
      # @option opts (see #track)
      def years(opts={})
        perform_get_request('years.json', opts)
      end



      # @api private
      def select_params(params, keys)
        _params = {}
        keys.each do |key|
          _params[key] = params[key] if params.key?(key)
        end
        return _params
      end

      # @api private
      def assert_response_data_field(response)
        raise Phishin::Client::EmptyResponseError.new(response.url) if !response.data
      end

      # @api private
      def perform_get_request(path, opts)
        opts ||= {}
        url = [BASE_URL, path].join("/")
        force  = opts.delete(:force)
        params = opts.delete(:params) || {}
        key = [path,
                  [params.to_a.sort.map { |e| e.join('=')}].join('&')]
                .join('?').chomp('?')

        json_str = ::Phishin::Client::Cache.fetch(key, force: force) do
          logger.info "phish.in api GET url=#{url} params=#{params}" if logger
          RestClient.get(url, HEADERS.merge(params: params)).to_s
        end

        resp = Phishin::Api::Response.new(url, JSON.load(json_str))
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

