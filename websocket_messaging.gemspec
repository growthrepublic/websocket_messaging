# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'websocket_messaging/version'

Gem::Specification.new do |spec|
  spec.name          = "websocket_messaging"
  spec.version       = WebsocketMessaging::VERSION
  spec.authors       = ["Artur Hebda"]
  spec.email         = ["arturhebda@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "redis", "~> 3.0.7"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.0.0.rc1"
  spec.add_development_dependency "rspec-its", "~> 1.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0.0.rc1"
end
