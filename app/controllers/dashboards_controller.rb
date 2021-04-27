class DashboardsController < ApplicationController
  before_action :authenticate_user!  #unremark
  
  def show
    @user = current_user
    #@user = User.first # remark
  end

end