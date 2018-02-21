class AddAnswersToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :question_id, :integer, index: true
  end
end
