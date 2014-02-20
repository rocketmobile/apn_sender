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

    it "sends the client a notification" do
      APN.stub(:connection_pool).and_return(ConnectionPool.new(size: 1, timeout: 5){ client })

      client.should_receive(:push) do |message|
        message.should.eql? notification
      end

      APN.notify_sync(token, payload)
    end
  end
end
