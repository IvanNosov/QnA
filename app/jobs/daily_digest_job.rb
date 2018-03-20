class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Subscription.send_daily_digest
  end
end
