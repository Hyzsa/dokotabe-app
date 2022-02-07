class CreateDisplayedShops < ActiveRecord::Migration[6.1]
  def change
    create_table :displayed_shops do |t|
      t.integer :user_id
      t.string :shop_id
      t.string :shop_name
      t.string :shop_photo
      t.datetime :displayed_date

      t.timestamps
    end
  end
end
