class CreateGalleryItems < ActiveRecord::Migration
  def change
    create_table :gallery_items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :disabled, default: false

      t.timestamps null: false
    end
  end
end
