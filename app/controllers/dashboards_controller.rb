class DashboardsController < ApplicationController
  #before_action :authenticate_user!  
  
  def show
    @user = current_user
    @user = User.first
  end

end