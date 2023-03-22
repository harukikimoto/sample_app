class AddAuthorityFlagToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authority_flag, :boolean, default: user, null: user
  end
end
