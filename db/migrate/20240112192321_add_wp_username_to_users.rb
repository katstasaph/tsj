class AddWpUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wp_username, :string
  end
end
