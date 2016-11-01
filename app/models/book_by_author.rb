class BookByAuthor < ActiveRecord::Base
  belongs_to :book
  belongs_to :author
  accepts_nested_attributes_for :author

  validates :book_id, presence: true
  validates :author_id, presence: true
  validates_uniqueness_of :author_id, scope: :book_id
end
