class CreateBookByGenres < ActiveRecord::Migration
  def change
    create_table :book_by_genres do |t|
      t.integer :book_id
      t.integer :genre_id

      t.timestamps null: false
    end
  end
end
