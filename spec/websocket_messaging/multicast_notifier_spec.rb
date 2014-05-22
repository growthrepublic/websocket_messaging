require "spec_helper"
require "websocket_messaging/multicast_notifier"

describe WebsocketMessaging::MulticastNotifier do
  describe "#new" do
    let(:channels) { [1, 2] }
    let(:notifier) { double("channel notifier") }
    let(:notifier_builder) do
      double(call: notifier)
    end

    it "creates a notifier for each channel" do
      multicast = described_class.new(channels, notifier_builder)
      expect(notifier_builder).to have_received(:call).with(1)
      expect(notifier_builder).to have_received(:call).with(2)
      expect(multicast.notifiers).to match_array [notifier, notifier]
    end
  end

  describe "#notify" do
    let(:message) { "message" }
    let(:channels) { [1, 2] }
    let(:notifier_builder) do
      ->(channel_id) { double(notify: nil) }
    end

    subject { described_class.new(channels, notifier_builder) }

    it "notifies all channels" do
      subject.notify(message)
      subject.notifiers.each do |notifier|
        expect(notifier).to have_received(:notify).with(message)
      end
    end
  end
end