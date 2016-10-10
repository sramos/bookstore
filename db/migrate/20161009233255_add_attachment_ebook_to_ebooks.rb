class AddAttachmentEbookToEbooks < ActiveRecord::Migration
  def self.up
    change_table :ebooks do |t|
      t.attachment :ebook
    end
  end

  def self.down
    remove_attachment :ebooks, :ebook
  end
end
