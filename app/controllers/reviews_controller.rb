class ReviewsController < ApplicationController
  before_action :associate_song, :except => [:index, :new, :create]
  before_action :authenticate_user!

  def index
    authorize Review
    @reviews = Review.all_unpublished
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
      @song.update_score!
      flash[:notice] = "Added review!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @review = Review.find(params[:id])
    authorize @review
    if @review.can_edit?(current_user.name)
      @review.lock!(current_user.name)
    else
      flash[:notice] = "This review is being edited by #{@review.current_editor} and is currently locked."
      redirect_to root_path
    end 
  end
  
  def update
    review = Review.find(params[:id])
    authorize review
    if review.update(review_params)
      @song.update_score!
      review.unlock!
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
    @song.update_score!
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
