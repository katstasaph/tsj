class AdminController < ApplicationController

  def index
    authorize :admin, :index?
  end
  
  def show
    authorize :admin, :show?
 end
end
