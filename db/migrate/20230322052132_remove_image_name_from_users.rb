class RemoveImageNameFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :image_name, :string
  end
end
