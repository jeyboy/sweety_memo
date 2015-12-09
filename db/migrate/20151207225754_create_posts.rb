class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name, null: false
      t.integer :topic_id, null: false
      t.boolean :disabled, default: false
      t.text :body, null: false
      
      t.timestamps null: false
    end
  end
end
