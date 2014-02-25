begin
  require 'resque'
  require 'apn/jobs/resque_notification_job'
rescue LoadError => e
  $stderr.puts "You don't have resque installed in your application. Please add it to your Gemfile and run bundle install"
  raise e
end

module APN
  module Backend
    class Resque
      def notify(token, opts, app_options={})
        ::Resque.enqueue(APN::Jobs::ResqueNotificationJob, token, opts, app_options={})
      end
    end
  end
end
