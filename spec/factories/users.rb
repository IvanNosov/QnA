FactoryBot.define do
  sequence :email do
    Faker::Internet.unique.email
  end
  factory :user do
    email
    password '123456'
    password_confirmation '123456'
  end
end