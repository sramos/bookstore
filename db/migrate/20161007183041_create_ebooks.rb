class CreateEbooks < ActiveRecord::Migration
  def change
    create_table :ebooks do |t|
      t.integer :book_id

      t.timestamps null: false
    end
  end
end
