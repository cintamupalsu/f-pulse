class JobMastersController < ApplicationController
  before_action :authenticate_user! #unremark
  before_action :correct_user
  def show
    @job_master = JobMaster.find(params[:id])
  end

  def new
    @job_master = JobMaster.new
  end

  def create
    @job_master = JobMaster.new(job_master_params)
    if @job_master.save
      flash[:success]=@job_master.content+"を登録しました。"
      redirect_to job_masters_path
    else
      render 'new'
    end
  end

  def update
    @job_master = JobMaster.find(params[:id])
    if @job_master.update(job_master_params)
      flash[:success]= "作業内容を編集しました"
      redirect_to job_masters_path
    else
      render 'edit'
    end
  end

  def index
    #@current_user = User.first
    @job_masters = JobMaster.all.order(:order).paginate(page: params[:page], :per_page => 10)
    @page = params[:page]
  end

  def edit
    @job_master = JobMaster.find(params[:id])
  end

  def destroy
    JobMaster.find(params[:id]).destroy
    flash[:success] = "作業内容を削除しました。"
    redirect_to job_masters_path
  end

  private

  def job_master_params
    params.require(:job_master).permit(:content, :order)
  end

  def correct_user
    #current_user = User.first # remark
    redirect_to(root_url) unless current_user.admin?
  end

end
