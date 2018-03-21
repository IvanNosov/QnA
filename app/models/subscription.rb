class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def self.send_daily_digest
    User.all.each do |user|
      DailyMailer.daily_digest(user.email).deliver_later
    end
  end
end
