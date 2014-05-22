# WebsocketMessaging

[![Code Climate](https://codeclimate.com/github/growthrepublic/websocket_messaging.png)](https://codeclimate.com/github/growthrepublic/websocket_messaging)

This gem has been extracted from chat application based on websockets. It consists of basically two components: channels and notifiers. Channels are meant to handle external communication through provided socket in a bidirectional manner while using notifiers for internal communication. Notifiers are using a messaging bus, which might be anything supporting publish/subscribe pattern across multiple threads / processes, i.e. common Redis cluster. It lets you define your own handlers for receiving and sending data.

## Installation

Add this line to your application's Gemfile:

    gem 'websocket_messaging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install websocket_messaging

## Usage

### Internal Bus

Before sending any messages `WebsocketMessaging::Notifier.bus_connector` has to be set up. If you have `Redis` running on your server, then you can simply set it to return a new redis client instance each time as follows:

`WebsocketMessaging::Notifier.bus_connector = -> { Redis.new }`

If you are using Rails, put this line to `config/initializers/websocket_messaging.rb`.

### Passing socket

Gem expects socket to respond to following methods: `onclose(&block)`, `onmessage(&block)` and `send_data(msg)`.

### Example

TODO! Stay tuned, we are going to open source one of our Rails apps which this gem was extracted from.

## Contributing

1. Fork it ( https://github.com/growthrepublic/websocket_messaging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
