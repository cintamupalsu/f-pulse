class GoodMastersController < ApplicationController
  before_action :authenticate_user! #unremark
  before_action :correct_user
  
  def index 
    @good_masters = GoodMaster.all.order(:order).paginate(page: params[:page], :per_page => 10)
    @page = params[:page]
  end

  def new
    @good_master = GoodMaster.new
  end

  def create
    @good_master = GoodMaster.new(good_master_params)
    if @good_master.save
      flash[:success]= "👩🏻‍💼"+@good_master.content+"を登録しました。"
      redirect_to good_masters_path
    else
      render 'new'
    end
  end

  def show
    @good_master = GoodMaster.find(params[:id])
  end

  def edit
    @good_master = GoodMaster.find(params[:id])
  end

  def update
    @good_master = GoodMaster.find(params[:id])
    if @good_master.update(good_master_params)
      flash[:success]= "👩🏻‍💼"+@good_master.content+"を編集しました"
      redirect_to good_masters_path
    else
      render 'edit'
    end
  end

  def destroy
    GoodMaster.find(params[:id]).destroy
    flash[:success] = "👩🏻‍💼農作物を削除しました。"
    redirect_to good_masters_path
  end

  private

  def good_master_params
    params.require(:good_master).permit(:content, :order)
  end

  def correct_user
    redirect_to(root_url) unless current_user.admin?
  end
end
