module APN::Jobs
  # This is the class that's actually enqueued via Sidekiq when user calls +APN.notify+.
  # It gets added to the +apple_server_notifications+ Sidekiq queue, which should only be operated on by
  # workers of the +APN::Sender+ class.
  class SidekiqNotificationJob
    include Sidekiq::Worker
    # Behind the scenes, this is the name of our Sidekiq queue
    @queue = QUEUE_NAME

    # Build a notification from arguments and send to Apple
    def perform(token, opts, app_options={})
      log_id = "Creating async workers for apn_sender Notification(#{notification.id}): "
      logger.info log_id + 'starting'
      APN.notify_sync(token, opts, app_options={})
      logger.info log_id + 'done'
    end
  end
end