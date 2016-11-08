class CreateEbookByUser < ActiveRecord::Migration
  def change
    create_table :ebook_by_users do |t|
      t.integer :ebook_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
