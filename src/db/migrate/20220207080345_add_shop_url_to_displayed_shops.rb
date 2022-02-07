class AddShopUrlToDisplayedShops < ActiveRecord::Migration[6.1]
  def change
    add_column :displayed_shops, :shop_url, :string
  end
end
