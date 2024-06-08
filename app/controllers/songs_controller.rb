class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Song
    @songs = Song.list_available(policy_scope(Song.by_created), current_user)
	  @announcement = Announcement.find(1)
  end
  
  def show
    authorize Song
    @song = Song.with_reviews_and_users.find(params[:id])
  end
  
  def new
    authorize Song
    @song = Song.new
  end
  
  def create
    authorize Song
    @song = Song.new(song_params)
    if @song.save
      flash[:notice] = "Added song!"
      redirect_to action: :index
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    authorize Song
    @song = Song.find(params[:id])
  end
  
  def update
    authorize Song
    @song = Song.find(params[:id])
    if params[:pic] then @song.pic.attach(params[:pic]) end
    if @song.update(song_params)
      flash[:notice] = "Updated song!"
      redirect_to @song
    else
      flash[:alert] = "Error updating song."
      render :edit, status: :unprocessable_entity
    end
  end
  
  # Sends song data to WordPress site to schedule the corresponding post. 
  # other todo: optimize, this seems rather slow; move most of this to service
  def wp
    authorize Song
    @song = Song.find(params[:song_id])
    if Song.schedule_post!(@song, params[:post_time], current_user) 
      if @song.update({status: 2})
        flash[:notice] = "Scheduling successful!"    
      else 
        flash[:alert] = "Error updating song status, ping Katherine"
      end
      redirect_to root_path
    else
      flash[:alert] = "Error authenticating to WordPress API, ping Katherine"
      redirect_to root_path
    end
  end
  
  private 
  
  def song_params
    params.require(:song).permit(:artist, :title, :pic, :alttext, :audio, :video, :subhead, :status)
  end
end
