class AddPreviewLengthToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :preview_length, :integer
  end
end
