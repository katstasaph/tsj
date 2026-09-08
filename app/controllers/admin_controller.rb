class AdminController < ApplicationController

  def index
    authorize :admin, :index?
    @songs = Song.list_available(policy_scope(Song.by_created), current_user)
  end
  
  def show
    authorize :admin, :show?
  end
  
  # stopgap in lieu of login-as-user
  def manual_add_blurb
    authorize :admin, :index?
    redirect_to new_song_review_path(manual_add: true, song_id: params[:song_id])
  end
 
  # clean this up later, this is a quick dirty (hopeful) fix 
  def reposition
    authorize :admin, :index?
    Song.all.each do |song|
      idx = 1
      unless song.status == "published"
        song.reviews.each do |review|
          review.position = idx
          review.save!
          idx += 1
        end    
      end
    end
   flash[:notice] = "Reset positions."
   redirect_to admin_index_path 
  end

  # see above
  def clear_locks
    authorize :admin, :index?
    Review.all.each do |review|
      if review.current_editor 
        review.current_editor = nil
        review.save! 
      end
    end
   flash[:notice] = "Cleared all edit locks."
   redirect_to admin_index_path 
  end
  
  private
  
    def song_params
      params.require(:id)
    end

end
