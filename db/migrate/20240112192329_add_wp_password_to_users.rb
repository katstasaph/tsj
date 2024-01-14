class AddWpPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wp_password, :string
  end
end
