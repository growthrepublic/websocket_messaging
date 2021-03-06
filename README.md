# WebsocketMessaging

[![Code Climate](https://codeclimate.com/github/growthrepublic/websocket_messaging.png)](https://codeclimate.com/github/growthrepublic/websocket_messaging)
[![Build Status](https://travis-ci.org/growthrepublic/websocket_messaging.svg?branch=master)](https://travis-ci.org/growthrepublic/websocket_messaging)

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

    WebsocketMessaging::Notifier.bus_connector = -> { Redis.new }

If you are using Rails, put this line to `config/initializers/websocket_messaging.rb`.

### Example - excerpt from group conversation
    channel_id  = "sport"
    channel_ids = %w(sport weather)

    channel = WebsocketMessaging::Channel.new(channel_id) do |channel|
      channel.onmessage do |data|
        channel.notifier.multicast(channel_ids).notify(data)
      end
    end

    channel.start(socket)
    # see the requirements about socket below

### Passing socket

Gem expects socket to respond to following methods: `onclose(&block)`, `onmessage(&block)` and `send_data(msg)`. This requirements can be met by [tubesock](https://github.com/ngauthier/tubesock). To find out more check sample chat app below.

### Sample chat app

If you are looking for a ready-to-use app, check out our [sample chat](https://github.com/growthrepublic/chat).

## Contributing

1. Fork it ( https://github.com/growthrepublic/websocket_messaging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

