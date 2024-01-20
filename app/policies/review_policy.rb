class ReviewPolicy < SongPolicy
  attr_reader :user, :review

  def initialize(user, review)
    @user = user
    @review = review
  end
 
  def index?
    user.admin? or user.editor?
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def move?
    update?
  end

  def update?
    user.admin? or user.editor? or @review.user_id == user.id
  end 

  def create?
    true
  end

  def destroy?
    user.admin? or user.editor?
  end
end