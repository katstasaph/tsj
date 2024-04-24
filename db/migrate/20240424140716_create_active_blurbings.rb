class CreateActiveBlurbings < ActiveRecord::Migration[7.1]
  def change
    create_table :active_blurbings, if_not_exists: true do |t|
      t.string :blurber
      t.references :song, null: false, foreign_key: true
      t.timestamps
    end
  end
end
