class RemoveWorkingHoursFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :working_hour, :datetime
  end
end
