class AdminPolicy < UserPolicy
  attr_reader :user

  def initialize(user, _rec)
    @user = user
  end
 
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end
end