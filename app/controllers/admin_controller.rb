class AdminController < ApplicationController

  def index
    authorize :admin, :index?
  end
  
  def show
    authorize :admin, :show?
  end
 
  # clean this up later, this is a quick dirty (hopeful) fix 
  def reposition
    authorize :admin, :index?
    Song.all.each do |song|
      idx = 1
      unless song.status == "published"
        song.reviews.each do |review|
		  p review
          review.position = idx
          review.save!
          idx += 1
        end    
      end
    end
   flash[:notice] = "Reset positions."
   redirect_to admin_index_path 
  end
end
