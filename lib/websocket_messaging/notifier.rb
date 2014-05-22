require 'json'
require 'websocket_messaging/multicast_notifier'

module WebsocketMessaging
  class BusConnectorNotDefinedError < StandardError; end

  class Notifier < Struct.new(:channel_id)
    def subscribe(&block)
      @subscription = Thread.new do
        connect_to_bus.subscribe(channel_id) do |bus|
          bus.message do |channel, message|
            data = JSON.parse(message)
            block.call(data)
          end
        end
      end
    end

    def multicast(channel_ids)
      MulticastNotifier.new(channel_ids, self.class.public_method(:new))
    end

    def notify(message)
      return unless message && message.respond_to?(:to_json)
      connect_to_bus.publish(channel_id, message.to_json)
    end

    def unsubscribe
      @subscription.kill
    end

    def connect_to_bus
      self.class.bus_connector.call
    end

    def self.bus_connector=(connector)
      @bus_connector = connector
    end

    def self.bus_connector
      unless @bus_connector
        raise BusConnectorNotDefinedError,
          %[you have to define a bus connector,
            i.e. returning a new connection to redis]
      end

      @bus_connector
    end
  end
end