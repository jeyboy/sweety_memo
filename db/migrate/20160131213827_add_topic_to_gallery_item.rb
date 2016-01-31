class AddTopicToGalleryItem < ActiveRecord::Migration
  def change
    add_column :gallery_items, :gallery_topic_id, :integer
  end
end
