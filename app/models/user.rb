class User < ApplicationRecord
  enum role: [:writer, :editor, :admin], _default: :writer
  has_many :reviews
  
  validates :username, presence: true
  validates :password_confirmation, presence: true, on: :create
  validates :email, :uniqueness => {:allow_blank => true}
  
  default_scope { order(created_at: :desc) }

  def set_default_role
    self.role ||= :writer
  end
  
  def set_admin_role
    self.role ||= :admin
  end

  def editor_or_above?
    editor? || admin?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :registerable, :rememberable
end
