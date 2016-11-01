class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
	 :timeoutable, :lockable

  after_initialize :set_default_rol, if: :new_record?
  enum rol: [:user, :admin]

 private

  # Default rol for new records
  def set_default_rol
    self.rol ||= :user
  end
end
