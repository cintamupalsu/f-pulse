class DashboardsController < ApplicationController
  before_action :authenticate_user!  #unremark
  
  def show
    # @user = current_user
    # @user = User.first # remark
    # current_user = User.first # remark
  end

  def qr_show
    # current_user = User.first # remark
    content = "EIEIO"+current_user.id.to_s
    size = '3'
    level = :h 
    @qrcode = RQRCode::QRCode.new(content, :size => 5, :level => :h)
  end

end