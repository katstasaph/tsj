class UserPolicy < ApplicationPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user 
    @account = account
  end

  def index?
    user.editor_or_above?
  end

  def show?
    user.editor_or_above?
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