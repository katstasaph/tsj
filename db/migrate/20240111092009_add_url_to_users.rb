class AddUrlToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :url, :string
  end
end
