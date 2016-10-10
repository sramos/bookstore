class Genre < ActiveRecord::Base
  has_many :book_by_genres, dependent: :destroy
  has_many :books, through: :book_by_genres

  validates :name, presence: true
end
