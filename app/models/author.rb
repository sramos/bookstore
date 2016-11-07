class Author < ActiveRecord::Base
  has_many :book_by_authors, dependent: :destroy
  has_many :books, through: :book_by_authors

  validates :name, presence: true
  before_destroy :verify_deletion

  # Class methods
  class << self
    def search string
      find.order(:name).where(['name LIKE ?', '%' + string + '%'])
    end
    def get_name temp_name 
      full_name = /(.+),\s(.+)/.match(temp_name)
      full_name ? full_name[2] + " " + full_name[1] : temp_name
    end   
  end

 private

  # Allow author deletion only if there is no books associated
  def verify_deletion
    errors.add( "books", "there are books associated" ) unless self.book_by_authors.empty?
  end
          
    def verify_name
      full_name = /(.+),\s(.+)/.match(self.name)
      self.name = full_name[2] + " " + full_name[1] if full_name
    end
end
