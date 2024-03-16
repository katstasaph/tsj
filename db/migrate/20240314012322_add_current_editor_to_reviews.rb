class AddCurrentEditorToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :current_editor, :string
  end
end
