class AddAlttextToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :alttext, :string
  end
end
