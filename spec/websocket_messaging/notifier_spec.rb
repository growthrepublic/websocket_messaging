require "spec_helper"

require 'redis'
require 'websocket_messaging/notifier'
require 'websocket_messaging/multicast_notifier'

describe WebsocketMessaging::Notifier do
  describe "#multicast" do
    let(:channel_id) { 1 }
    let(:channel_ids) { [2, 3] }
    let(:notifier_builder) { described_class.public_method(:new) }

    subject { described_class.new(channel_id) }

    it "creates multicast notifier for passed channels" do
      expect(WebsocketMessaging::MulticastNotifier).to receive(:new)
        .with(channel_ids, notifier_builder)

      subject.multicast(channel_ids)
    end
  end

  describe "#notify" do
    let(:bus_connection) { double("bus", publish: nil) }
    let(:bus_connector)  { double(call: bus_connection) }
    let(:parsed_data)    { { "a" => 3 } }
    let(:raw_data)       { parsed_data.to_json }
    let(:channel_id)     { 1 }

    subject { described_class.new(channel_id) }

    before(:each) do
      described_class.bus_connector = bus_connector
    end

    context "message responding to :to_json" do
      it "publishes to bus on the related channel" do
        subject.notify(parsed_data)

        expect(bus_connection).to have_received(:publish)
          .with(channel_id, raw_data)
      end
    end

    context "other messages" do
      it "does not publish anything" do
        subject.notify(nil)
        expect(bus_connection).to_not have_received(:publish)
      end
    end
  end

  describe "messaging flow through bus" do
    before(:all) do
      described_class.bus_connector = -> { Redis.new }
    end

    let(:channel_id)  { 1 }
    let(:parsed_data) { { "a" => 3 } }
    let(:receiver)    { double("receiver", call: nil) }

    subject { described_class.new(channel_id) }

    it "allows to receive messages sent on the channel" do
      subject.subscribe do |data|
        receiver.call(data)
      end

      subject.notify(parsed_data)
      subject.unsubscribe

      expect(receiver).to have_received(:call).with(parsed_data)
    end
  end
end