class AddUserToAnswersQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :user_id, :integer, index: true
    add_column :questions, :user_id, :integer, index: true
  end
end
