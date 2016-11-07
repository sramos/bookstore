class BookByAuthor < ActiveRecord::Base
  belongs_to :book
  belongs_to :author
  accepts_nested_attributes_for :author

  validates :book, presence: true
  validates :author, presence: true
  validates_uniqueness_of :author_id, scope: :book_id
end
