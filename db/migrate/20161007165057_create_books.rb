class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn
      t.text :description

      t.timestamps null: false
    end
  end
end
