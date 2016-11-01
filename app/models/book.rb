class Book < ActiveRecord::Base
  has_many :book_by_authors, inverse_of: :book, dependent: :destroy
  has_many :authors, through: :book_by_authors
  has_many :book_by_genres, inverse_of: :book, autosave: true, dependent: :destroy
  has_many :genres, through: :book_by_genres
  has_many :ebooks, inverse_of: :book, dependent: :destroy

  has_attached_file :cover, styles: { medium: "200x300", thumb: "100x150" }, default_url: "/images/no_cover_:style.gif"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  accepts_nested_attributes_for :book_by_authors, allow_destroy: true
  accepts_nested_attributes_for :book_by_genres, allow_destroy: true
  accepts_nested_attributes_for :ebooks, allow_destroy: true

  validates_associated :book_by_authors
  validates_associated :book_by_genres
  validates_associated :ebooks
end
