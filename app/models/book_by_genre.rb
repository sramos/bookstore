class BookByGenre < ActiveRecord::Base
  belongs_to :book, inverse_of: :book_by_genres
  belongs_to :genre

  # Por algun motivo, esto rompe la creacion encadenada
  # a pesar de que en Book tenemos un inverse_of en la relacion
  validates :book, presence: true
  validates :genre, presence: true
  validates_uniqueness_of :genre_id, scope: :book_id
end
