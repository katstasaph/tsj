class UserPolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user 
    @account = account
  end

  def index?
    user.admin? || user.editor?
  end

  def show?
    user.admin? || user.editor?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end