class Authorization < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
