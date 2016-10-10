class BookByAuthor < ActiveRecord::Base
  belongs_to :book
  belongs_to :author

  validates :book_id, presence: true
  validates :author_id, presence: true
end
