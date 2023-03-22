class AddWorkingHoursToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :working_hour, :datetime
  end
end
