class Question < ApplicationRecord
  include Author
  include Voteable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :voteable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments
end
