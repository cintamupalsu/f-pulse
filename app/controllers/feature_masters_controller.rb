class FeatureMastersController < ApplicationController
  before_action :authenticate_user! #unremark
  before_action :correct_user
  
  def index 
    @feature_masters = FeatureMaster.all.order(:content).paginate(page: params[:page], :per_page => 10)
    @page = params[:page]
  end

  def new
    @feature_master = FeatureMaster.new
  end

  def create
    @feature_master = FeatureMaster.new(feature_master_params)
    if @feature_master.save
      flash[:success]= "π©π»βπΌ"+@feature_master.content+"γη»ι²γγΎγγγ"
      redirect_to feature_masters_path
    else
      render 'new'
    end
  end

  def show
    @feature_master = FeatureMaster.find(params[:id])
  end

  def edit
    @feature_master = FeatureMaster.find(params[:id])
  end

  def update
    @feature_master = FeatureMaster.find(params[:id])
    if @feature_master.update(feature_master_params)
      flash[:success]= "π©π»βπΌ"+@feature_master.content+"γη·¨ιγγΎγγ"
      redirect_to feature_masters_path
    else
      render 'edit'
    end
  end

  def destroy
    FeatureMaster.find(params[:id]).destroy
    flash[:success] = "π©π»βπΌθΎ²δ½η©γει€γγΎγγγ"
    redirect_to feature_masters_path
  end

  private

  def feature_master_params
    params.require(:feature_master).permit(:content, :abrev, :master)
  end

  def correct_user
    redirect_to(root_url) unless current_user.admin?
  end  

end
