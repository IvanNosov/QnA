class Answer < ApplicationRecord
  include Author
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
end
