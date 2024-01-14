class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
	  t.string :artist, null: false
	  t.string :title, null: false
	  t.string :audio
	  t.string :video
	  t.integer :status, null: false
      t.timestamps
    end
  end
end
