class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.datetime :start_time
      t.datetime :finish_time
      t.integer :break_time
      t.string :comment
      t.string :owner_comment
      t.integer :user_id

      t.timestamps
    end
  end
end
