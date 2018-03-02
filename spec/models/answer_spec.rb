require 'rails_helper'

describe Answer do
  it { should belong_to :question }
  it { should belong_to(:user) }
  it { should have_many :attachments }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
  it { should accept_nested_attributes_for :attachments }
end
