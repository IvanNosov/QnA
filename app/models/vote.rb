class Vote < ApplicationRecord
  include Author
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :voteable, polymorphic: true

  validates_uniqueness_of :user, scope: %i[voteable_type voteable_id], message: "you have already voted"

  validate :author_error

  def author_error
    errors.add(:author, "can't vote!") if voteable.user == user
  end
end
