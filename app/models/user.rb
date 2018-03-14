class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: [:facebook]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations

  validates :email, :password, presence: true

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    binding.pry
    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
end
end
