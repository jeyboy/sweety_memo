class CreateGalleryTopics < ActiveRecord::Migration
  def change
    create_table :gallery_topics do |t|
      t.string :name, null: false
      t.boolean :disabled, default: false

      t.timestamps null: false
    end
  end
end
