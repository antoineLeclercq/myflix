class AddTokenToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :token, :string
  end
end
