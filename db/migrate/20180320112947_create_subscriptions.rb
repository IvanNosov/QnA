class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions, &:timestamps
    add_reference :subscriptions, :user, foreign_key: true
    add_reference :subscriptions, :question, foreign_key: true
    add_index :subscriptions, %i[user_id question_id], unique: true
  end
end
