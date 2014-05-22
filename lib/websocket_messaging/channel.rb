require 'websocket_messaging/notifier'

module WebsocketMessaging
  class Channel
    attr_reader :notifier, :socket

    def initialize(id)
      @notifier = Notifier.new(id)
      @handlers = {
        before_send: ->(data) { data },
        onmessage:   ->(data) {}
      }

      yield self if block_given?
    end

    def start(socket)
      @socket = socket

      subscribe_notifier
      subscribe_socket_messages
      subscribe_socket_closed
    end

    def subscribe_notifier
      notifier.subscribe do |data|
        send_socket_message(data)
      end
    end

    def subscribe_socket_messages
      socket.onmessage do |message|
        data = JSON.parse(message)
        receive_message(data)
      end
    end

    def subscribe_socket_closed
      socket.onclose do
        notifier.unsubscribe
      end
    end

    def onmessage(&handler)
      @handlers[:onmessage] = handler
    end

    def before_send(&handler)
      @handlers[:before_send] = handler
    end

    private

    def send_socket_message(data)
      to_send = @handlers[:before_send].call(data)
      if to_send && to_send.respond_to?(:to_json)
        socket.send_data(to_send.to_json)
      end
    end

    def receive_message(data)
      @handlers[:onmessage].call(data)
    end
  end
end