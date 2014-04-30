# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'date'
require 'phishin/client/version'

Gem::Specification.new do |gem|
  gem.name        = 'phishin-client'
  gem.version     = Phishin::Client::VERSION
  gem.date        = Date.today.to_s
  gem.licenses    = ['MIT']
  gem.authors     = ['Alexander Bird']
  gem.email       = ['alexebird@gmail.com']
  gem.homepage    = 'https://github.com/alexebird/phishin-client'
  gem.summary     = %q{Phish.in API client}
  gem.description = %q{Client for http://phish.in Phish streaming API.}

  gem.required_ruby_version     = '>= 1.9.3'

  gem.add_runtime_dependency 'rest-client', '~> 1.6.7'
  gem.add_runtime_dependency 'oj', '~> 2.1.7'
  #gem.add_runtime_dependency 'nokogiri', '~> 1.6.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'yard', '~> 0.8'
  #gem.add_development_dependency 'redcarpet', '~> 3.0'
  #gem.add_development_dependency 'simplecov', '~> 0.7.1'

  gem.files       = `git ls-files`.split($/)
  gem.test_files  = gem.files.grep(%r{^spec/})

  gem.require_paths = ['lib']
end

