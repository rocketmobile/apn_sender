require 'spec_helper'
describe APN do

  let(:client) do
    APN::Client.new
  end

  let(:token) { "2589b1aa 363d23d8 d7f16695 1a9e3ff4 1fb0130a 637d6997 a2080d88 1b2a19b5" }
  let(:payload) {"fake"}
  let(:notification) do
    APN::Notification.new(token, payload)
  end

  describe ".notify_sync" do

    context "with a single application" do

      it "sends the client a notification" do
        APN.stub(:connection_pool).and_return(ConnectionPool.new(size: 1, timeout: 5){ client })

        client.should_receive(:push) do |message|
          message.should.eql? notification
        end

        APN.notify_sync(token, payload)
      end
    end

    context "with multiple applications" do

      it "passes application options to with_connection proxy" do
        APN.should_receive(:with_connection).with({cert_path: 'foo', password: 'bar'})

        APN.notify_sync(token, payload, cert_path: 'foo', password: 'bar')
      end
      it "passes the notification to a client configured for the intended application" do
        pending "implementation via tests on with_connection and find_connection_pool unless inefficient"
        @pools


      end
    end
  end
end
