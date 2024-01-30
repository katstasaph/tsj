class AnnouncementPolicy < UserPolicy
  attr_reader :user
  
  def new?
    user.editor_or_above?
  end

  def edit?
    new?
  end

  def update?
    new?
  end 

  def create?
    new?
  end

  def destroy?
    new?
  end
end