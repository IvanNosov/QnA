class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.boolean :value
      t.integer :user_id
      t.references :voteable, polymorphic: true
      t.timestamps
    end
  end
end
