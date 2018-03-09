class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commentable_id
      t.string :commentable_type
      t.timestamps
    end

    add_reference :comments, :user, foreign_key: true
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
