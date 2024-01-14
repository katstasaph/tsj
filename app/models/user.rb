class User < ApplicationRecord
  enum role: [:writer, :editor, :admin], _default: :writer
  has_many :reviews
  validates :username, :password, presence: true
  validates :email, :uniqueness => {:allow_blank => true}

  def set_default_role
    self.role ||= :writer
  end
  
  def set_admin_role
    self.role ||= :admin
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # (:registerable removed, we don't want public signup)
  devise :database_authenticatable,
         :recoverable, :rememberable
end
