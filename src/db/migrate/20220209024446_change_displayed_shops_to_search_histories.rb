class ChangeDisplayedShopsToSearchHistories < ActiveRecord::Migration[6.1]
  def change
    rename_table :displayed_shops, :search_histories
  end
end
