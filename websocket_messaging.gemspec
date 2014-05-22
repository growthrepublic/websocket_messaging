# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'websocket_messaging/version'

Gem::Specification.new do |spec|
  spec.name          = "websocket_messaging"
  spec.version       = WebsocketMessaging::VERSION
  spec.authors       = ["Artur Hebda"]
  spec.email         = ["arturhebda@gmail.com"]
  spec.summary       = %[Messaging platform for sending json data that supports many-to-many
    connections using sockets, i.e. websockets.]
  spec.description   = %[This gem has been extracted from chat application based on websockets.
    It consists of basically two components: channels and notifiers. Channels are meant to handle
    external communication through provided socket in a bidirectional manner while
    using notifiers for internal communication. Notifiers are using a messaging bus,
    which might be anything supporting publish/subscribe pattern across multiple threads / processes,
    i.e. common Redis cluster. It lets you define your own handlers for receiving and sending data.]
  spec.homepage      = "https://github.com/growthrepublic/websocket_messaging"
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
