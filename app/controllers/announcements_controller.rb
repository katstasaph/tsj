class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  
  # Allowing multiple announcements so we can have editor-facing announcements as well
  # todo: announcements associated w/ songs?

  def show
    @announcement = Announcement.find(params[:id])
  end

  def new
    authorize Announcement
	@announcement = Announcement.new
  end
  
  def create
    authorize Announcement
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
      flash[:notice] = "Updated announcement!"
      redirect_to root_path
    else
      flash[:alert] = "Error creating announcement."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize Announcement
    @announcement = Announcement.find(params[:id])
    authorize @announcement
  end
  
  def update
    authorize Announcement
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
      flash[:notice] = "Updated announcement!"
      redirect_to root_path 
    else
      flash[:alert] = "Error updating announcement."
      render :edit, status: :unprocessable_entity
    end
  end  

  def destroy
    authorize Announcement
    @announcement = Announcement.find(params[:id])
    @announcement.destroy
    flash[:notice] = "Removed announcement."
    redirect_to root_path
  end
 
  private

  def announcement_params
    params.require(:announcement).permit(:content)
  end
 
end
