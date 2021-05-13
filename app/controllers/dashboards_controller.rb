class DashboardsController < ApplicationController
  before_action :authenticate_user!  #unremark
  
  def show
    #@user = User.first # remark
    #current_user = User.first # remark
    #@current_user = User.first # remark
  end

  def qr_show
    #current_user = User.first # remark
    content = "EIEIO"+current_user.uid.to_s+current_user.id.to_s
    @qrcode = RQRCode::QRCode.new(content, :size => 5, :level => :h)
  end

  def masters_maintenance
    #@current_user = User.first # remark
  end

end