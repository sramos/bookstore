class Book < ActiveRecord::Base
  has_many :book_by_authors, dependent: :destroy
  has_many :authors, through: :book_by_authors
  has_many :book_by_genres, dependent: :destroy
  has_many :genres, through: :book_by_genres
  has_many :ebooks, dependent: :destroy

  has_attached_file :cover, styles: { medium: "200x300", thumb: "100x150" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
end
