class ChangeDataTitleToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :working_hour, :integer
  end
end
