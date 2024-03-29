class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize User
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    # TODO Should probably put some validation here but ehhh
    @unpublished_only = request.query_parameters['unpublished_only']

    if @unpublished_only
      @reviews = Review.all_open.by_user(params[:id])
    else
      @reviews = Review.by_user(params[:id])
    end

    if @user != current_user
      authorize User
    end
  end
  
  def new
    authorize User
    @user = User.new
  end
  
  def create
    authorize User
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Added user!"
      redirect_to admin_index_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :name, :email, :role, :url, :wp_username, :wp_password)
  end
  
end

# Patches Devise to override default redirects, todo: get this out of this file

class RegistrationsController

  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end
end