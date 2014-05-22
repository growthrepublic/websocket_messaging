require "spec_helper"
require "websocket_messaging/channel"
require "websocket_messaging/notifier"

describe WebsocketMessaging::Channel do
  describe "#new" do
    let(:id) { 1 }

    it "creates a dedicated notifier" do
      expect(WebsocketMessaging::Notifier).to receive(:new)
        .with(id).and_call_original

      channel = described_class.new(id)
      expect(channel.notifier).to_not be_nil
    end

    it "passes self to a block if given" do
      config = double(call: nil)
      channel = described_class.new(id) do |channel|
        config.call(channel)
      end

      expect(config).to have_received(:call).with(channel)
    end
  end

  describe "#start" do
    let(:id)     { 1 }
    let(:socket) { double }

    subject { described_class.new(id) }

    it "subscribes to notifier and socket" do
      expect(subject).to receive(:subscribe_notifier)
      expect(subject).to receive(:subscribe_socket_messages)
      expect(subject).to receive(:subscribe_socket_closed)

      subject.start(socket)
    end
  end

  describe "internal notify" do
    let(:id)          { 1 }
    let(:parsed_data) { { "a" => 3 } }
    let(:raw_data)    { parsed_data.to_json }
    let(:changed_data){ parsed_data.merge("b" => 4) }
    let(:socket)      { double("socket", send_data: nil) }
    let(:notifier)    { double("notifier") }

    subject { described_class.new(id) }

    before(:each) do
      expect(WebsocketMessaging::Notifier).to receive(:new).and_return(notifier)

      expect(notifier).to receive(:subscribe) do |&handler|
        @internal_notify = handler
      end

      allow(subject).to receive(:subscribe_socket_closed)
      allow(subject).to receive(:subscribe_socket_messages)

      subject.start(socket)
    end

    context "default handler" do
      it "passes the received data" do
        @internal_notify.call(parsed_data)
        expect(socket).to have_received(:send_data).with(raw_data)
      end
    end

    context "handler returning object that responds to :to_json" do
      before(:each) do
        subject.before_send do |data|
          changed_data
        end
      end

      it "sends returned object cast to json" do
        @internal_notify.call(parsed_data)
        expect(socket).to have_received(:send_data).with(changed_data.to_json)
      end
    end

    context "handler returning false" do
      before(:each) do
        subject.before_send { |_| false }
      end

      it "does not send anything" do
        @internal_notify.call(parsed_data)
        expect(socket).to_not have_received(:send_data)
      end
    end
  end

  describe "message from socket" do
    let(:id)               { 1 }
    let(:parsed_data)      { { "a" => 3 } }
    let(:raw_data)         { parsed_data.to_json }
    let(:socket)           { double("socket") }
    let(:message_received) { double(call: nil) }

    subject { described_class.new(id) }

    before(:each) do
      expect(socket).to receive(:onmessage) do |&handler|
        @incoming_socket_message = handler
      end

      allow(subject).to receive(:subscribe_notifier)
      allow(subject).to receive(:subscribe_socket_closed)

      subject.start(socket)
    end

    context "defined handler" do
      it "gets called with parsed data" do
        subject.onmessage do |data|
          message_received.call(data) # simply pass through
        end

        @incoming_socket_message.call(raw_data)
        expect(message_received).to have_received(:call).with(parsed_data)
      end
    end
  end

  describe "socket closed" do
    let(:id)       { 1 }
    let(:socket)   { double("socket") }
    let(:notifier) { double("notifier", unsubscribe: nil) }

    subject { described_class.new(id) }

    before(:each) do
      expect(WebsocketMessaging::Notifier).to receive(:new).and_return(notifier)

      expect(socket).to receive(:onclose) do |&handler|
        @socket_closed = handler
      end

      allow(subject).to receive(:subscribe_socket_messages)
      allow(subject).to receive(:subscribe_notifier)

      subject.start(socket)
    end

    it "unsubscribes from notifier" do
      @socket_closed.call
      expect(notifier).to have_received(:unsubscribe)
    end
  end
end