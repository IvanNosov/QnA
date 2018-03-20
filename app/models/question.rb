class Question < ApplicationRecord
  include Author
  include Voteable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :voteable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments

  after_create :subscribe_user
  after_update :question_update_notification

  private

  def subscribe_user
    subscriptions.create(user_id: user_id)
  end

  def question_update_notification
    subscriptions.each do |subscription|
      QuestionMailer.update_notification(subscription.user, self).deliver_later
    end
  end
end
