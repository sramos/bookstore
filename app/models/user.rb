class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :timeoutable, :lockable

  has_many :ebook_by_users, dependent: :destroy
  has_many :ebooks, through: :ebook_by_users
  has_many :books, through: :ebooks

  after_initialize :set_default_rol, if: :new_record?
  enum rol: [:user, :admin]

 private

  # Default rol for new records
  def set_default_rol
    self.rol ||= :user
  end
end
