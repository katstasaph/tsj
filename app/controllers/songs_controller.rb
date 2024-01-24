class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Song
    @songs = Song.list_available(policy_scope(Song.by_created), current_user)
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
    @song.status = 0
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
    @song.pic.attach(params[:pic])
    if @song.update(song_params)
      flash[:notice] = "Updated song!"
      redirect_to @song
    else
      flash[:alert] = "Error updating song."
      render :edit, status: :unprocessable_entity
    end
  end
  
  # Sends song data to WordPress site to schedule the corresponding post.
  # todo: optimize, this seems rather slow, ideally get it out of controller?
  def wp
    authorize Song
    @song = Song.find(params[:song_id])
    subhead = @song.subhead.body.to_s[34..-15]
    title = "#{@song.artist} - #{@song.title}"
    blurbs = Song.collate_blurbs(subhead, @song.video, @song.score, @song.controversy, @song.reviews)
	p blurbs
    if schedule_wp(title, subhead, blurbs)
      if @song.update({status: 2})
        flash[:notice] = "Scheduling successful!"    
      else 
        flash[:alert] = "Error updating song status, ping Katherine"
      end
      redirect_to root_path
    else
      flash[:alert] = "Error scheduling via WordPress API, ping Katherine as this is probably her fault"
      redirect_to root_path
    end
  end
  
  private 
  
  def song_params
    params.require(:song).permit(:artist, :title, :pic, :audio, :video, :subhead, :status)
  end
  
  def schedule_wp(title, subhead, html)
    true
	# res = WordpressService.call(title, subhead, html, current_user)
    # res && res.code == "201"
  end
end
