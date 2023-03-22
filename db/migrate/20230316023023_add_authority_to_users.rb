class AddAuthorityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authority, :string

  end
end
