class Ebook < ActiveRecord::Base
  belongs_to :book
  has_attached_file :ebook, url: '/:class/:id/download/:style.:extension',
                            path: ':rails_root/ebooks/:class/:attachment/:id_partition/:style/:filename'

  validates_attachment_content_type :ebook, content_type: ["application/vnd.amazon.ebook",
							   "application/x-mobipocket-ebook",
							   "application/epub+zip",
                                                           "application/pdf", "text/plain"]
  validates :book_id, presence: true
end
