class AddContentTypeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :content_type, :integer, default: POST_TEXT_CONTENT
  end
end
