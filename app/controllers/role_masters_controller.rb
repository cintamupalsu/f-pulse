class RoleMastersController < ApplicationController
  before_action :authenticate_user! #unremark
  before_action :correct_user
  
  def index 
    @role_masters = RoleMaster.all.order(:content).paginate(page: params[:page], :per_page => 10)
    @page = params[:page]
  end

  def new
    @role_master = RoleMaster.new
  end

  def create
    @role_master = RoleMaster.new(role_master_params)
    if @role_master.save
      flash[:success]= "👩🏻‍💼"+@role_master.content+"を登録しました。"
      redirect_to role_masters_path
    else
      render 'new'
    end
  end

  def show
    @role_master = RoleMaster.find(params[:id])
  end

  def edit
    @role_master = RoleMaster.find(params[:id])
  end

  def update
    @role_master = RoleMaster.find(params[:id])
    if @role_master.update(role_master_params)
      flash[:success]= "👩🏻‍💼"+@role_master.content+"を編集しました"
      redirect_to role_masters_path
    else
      render 'edit'
    end
  end

  def destroy
    RoleMaster.find(params[:id]).destroy
    flash[:success] = "👩🏻‍💼農作物を削除しました。"
    redirect_to role_masters_path
  end

  private

  def role_master_params
    params.require(:role_master).permit(:content, :abrev, :description)
  end

  def correct_user
    redirect_to(root_url) unless current_user.admin?
  end
end

