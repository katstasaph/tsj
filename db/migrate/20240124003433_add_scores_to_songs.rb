class AddScoresToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :score, :numeric
    add_column :songs, :controversy, :numeric
  end
end
