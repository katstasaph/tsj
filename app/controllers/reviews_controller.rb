class ReviewsController < ApplicationController
  before_action :associate_song, :except => [:index, :new, :create]
  before_action :authenticate_user!

  def index
    authorize Review
    @reviews = Review.includes(:song, :user)
  end

  def new
    authorize Review
    @song = Song.find(params[:song_id])
    @review = @song.reviews.build
  end
  
  def create
    authorize Review
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
	authorize @review
  end
  
  def update
    review = Review.find(params[:id])
	authorize review
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
    authorize Review
    @review = Review.find(params[:id])
	@review.destroy
    flash[:notice] = "Deleted review."
	redirect_to @song
  end

  def move
    authorize Review
    @review = Review.find(params[:id])
    @review.insert_at(params[:newIndex].to_i + 1)
    head :ok
  end

  private
  
  def associate_song
    review = Review.find(params[:id])
    @song = Song.find_by(id: review.song_id)
  end
  
  def review_params
    params.require(:review).permit(:score, :content, :position)
  end

end
