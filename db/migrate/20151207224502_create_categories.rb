class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.boolean :disabled, default: false

      t.timestamps null: false
    end

    add_index :categories, :name, unique: true
  end
end
