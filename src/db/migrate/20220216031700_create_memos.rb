class CreateMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :memos do |t|
      t.integer :favorite_id
      t.text :content

      t.timestamps
    end
  end
end
