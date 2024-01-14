class AddPositionToReview < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :position, :integer
  end
end
