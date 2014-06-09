# Phish.in API Client

Talks to the http://phish.in API. Has built-in caching.

- [README](https://github.com/alexebird/phishin-client/blob/master/README.md)
- [Documentation](http://rubydoc.info/gems/phishin-client)
- [Phish.in API documentation](http://phish.in/api-docs)

## Installation

    gem install phishin-client


## Getting Started

```ruby
require 'phishin-client'

doglogger = Logger.new
c = Phishin::Client.new(log: true, logger: doglogger, cache_options: { memcached_servers: ['localhost:11211'] })

# to not use caching, specify the :cache => false option
p = Phishin::Client.new(cache: false)

response = c.tracks(params: { page: 1, per_page: 40 })  # Phishin::Api::Response instance
json_hash = response.data

# no caching for this request
response = c.tracks(params: { page: 1, per_page: 40 }, force: true)  # Phishin::Api::Response instance
```

## License

Please see [LICENSE](https://github.com/alexebird/phishin-client/blob/master/LICENSE.txt).


## Author

Alex Bird [@alexebird](https://twitter.com/alexebird).
Big thanks to [@phish_in](https://twitter.com/phish_in).
