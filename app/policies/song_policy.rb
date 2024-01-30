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
      if user.writer?
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
    user.editor_or_above?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    user.editor_or_above?
  end

  def create?
    user.editor_or_above?
  end

  def destroy?
    user.admin?
  end
  
  # todo: default to post under my username for reasons of realism
  def wp?
    (user.editor_or_above?) && (user.wp_username != "" && user.wp_password != "" )
  end
  
end