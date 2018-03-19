FactoryBot.define do
  factory :attachment do
    file do
      Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'))
    end
  end
end
