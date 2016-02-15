class AddOrderToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :order_pos, :integer, default: 0
  end
end
