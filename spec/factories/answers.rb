FactoryBot.define do
  factory :answer, class: 'Answer' do
    body 'MyString'
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end