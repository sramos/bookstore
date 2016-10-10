class Author < ActiveRecord::Base
  has_many :book_by_authors, dependent: :destroy
  has_many :books, through: :book_by_authors

  validates :name, presence: true
end
