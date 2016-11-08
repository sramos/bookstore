class EbookByUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :ebook

  validates :ebook, presence: true
  validates :user, presence: true
  validates_uniqueness_of :ebook_id, scope: :user_id
end
