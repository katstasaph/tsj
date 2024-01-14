class ReviewsController < ApplicationController
  before_action :associate_song, :except => [:index, :new, :create]
  before_action :authenticate_user!

  def index
    @reviews = Review.includes(:song, :user)
  end

  def new
    @song = Song.find(params[:song_id])
    @review = @song.reviews.build
  end
  
  def create
    @song = Song.find_by(id: params[:song_id])
    @review = @song.reviews.build(review_params)
	@review.user = current_user
    if @review.save
	  p "successful path"
      flash[:notice] = "Added review!"
      redirect_to root_path
    else
	 p "unsuccessful"
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @review = Review.find(params[:id])
  end
  
  def update
    review = Review.find(params[:id])
    if review.update(review_params)
      flash[:notice] = "Updated review."
	  if policy(Review).index?
        redirect_to @song
	  else
	    redirect_to root_path
	  end
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @review = Review.find(params[:id])
	@review.destroy
    flash[:notice] = "Deleted review."
	redirect_to @song
  end

  private
  
  def associate_song
    review = Review.find(params[:id])
    @song = Song.find_by(id: review.song_id)
  end
  
  def review_params
    params.require(:review).permit(:score, :content)
  end

end
