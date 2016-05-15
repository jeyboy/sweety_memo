class AddTagToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :tag, :integer, default: 0
  end
end
