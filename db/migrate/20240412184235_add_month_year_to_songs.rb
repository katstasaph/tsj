class AddMonthYearToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :month_year, :string
  end
end
