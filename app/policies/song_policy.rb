class SongPolicy < ApplicationPolicy
  attr_reader :user, :song

  def initialize(user, song)
    @user = user
    @song = song
  end
  
  class Scope < Scope
   def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.editor?
        scope.where(status: :open)
      else
        scope.all
      end
    end
  end

  def index?
    true
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
    user.admin? || user.editor?
  end

  def create?
    user.admin? || user.editor?
  end

  def destroy?
    user.admin?
  end
end