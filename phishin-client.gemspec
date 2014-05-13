# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'phishin/client/version'

Gem::Specification.new do |spec|
  spec.name          = "phishin-client"
  spec.version       = Phishin::Client::VERSION
  spec.date          = Date.today.to_s
  spec.authors       = ["Alex Bird"]
  spec.email         = ["alexebird@gmail.com"]
  spec.summary       = %q{Phish.in API client}
  spec.description   = %q{Client for http://phish.in Phish streaming API.}
  spec.homepage      = "https://github.com/alexebird/phishin-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", "~> 1.6.7"
  spec.add_runtime_dependency "oj", "~> 2.8.1"
  spec.add_runtime_dependency "hashie", "~> 2.1.1"
  spec.add_runtime_dependency "dalli", "~> 2.7.0"
  spec.add_runtime_dependency "redis", "~> 3.0.5"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard", "~> 0.8"
end

