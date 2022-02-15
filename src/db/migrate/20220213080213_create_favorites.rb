class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :search_history_id
      t.string :shop_id

      t.timestamps
    end
  end
end
