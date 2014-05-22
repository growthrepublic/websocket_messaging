module WebsocketMessaging
  class MulticastNotifier
    attr_reader :notifiers

    def initialize(channel_ids, notifier_builder)
      @notifiers = Array(channel_ids).map do |channel_id|
        notifier_builder.call(channel_id)
      end
    end

    def notify(message)
      @notifiers.each { |n| n.notify(message) }
    end
  end
end