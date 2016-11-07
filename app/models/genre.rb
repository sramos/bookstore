class Genre < ActiveRecord::Base
  has_many :book_by_genres, dependent: :destroy
  has_many :books, through: :book_by_genres

  validates :name, presence: true

  # Class methods
  class << self
    def search string
      find.order(:name).where(['name LIKE ?', '%' + string + '%'])
    end
    def get_name temp_name 
      temp_name.mb_chars.downcase.to_s
    end   
  end
end
