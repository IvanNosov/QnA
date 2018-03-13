class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments

  validates :email, :password, presence: true

  def author_of?(resource)
    id == resource.user_id
  end
end
