class User < ApplicationRecord
  enum role: [:writer, :editor, :admin], _default: :writer
  has_many :reviews
  validates :username, presence: true
  validates :password_confirmation, presence: true, on: :create
  validates :email, :uniqueness => {:allow_blank => true}

  def set_default_role
    self.role ||= :writer
  end
  
  def set_admin_role
    self.role ||= :admin
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :registerable, :rememberable
end
