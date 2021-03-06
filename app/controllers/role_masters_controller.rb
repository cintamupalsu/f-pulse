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
      flash[:success]= "π©π»βπΌ"+@role_master.content+"γη»ι²γγΎγγγ"
      redirect_to role_masters_path
    else
      render 'new'
    end
  end

  def edit
    @role_master = RoleMaster.find(params[:id])
  end

  def update
    @role_master = RoleMaster.find(params[:id])
    if @role_master.update(role_master_params)
      flash[:success]= "π©π»βπΌ"+@role_master.content+"γη·¨ιγγΎγγ"
      redirect_to role_masters_path
    else
      render 'edit'
    end
  end

  def destroy
    RoleMaster.find(params[:id]).destroy
    flash[:success] = "π©π»βπΌθΎ²δ½η©γει€γγΎγγγ"
    redirect_to role_masters_path
  end

  def show
    @role_master = RoleMaster.find(params[:id])
    @feature_masters = FeatureMaster.all.order(:content)
    #@current_user = User.first #remark
  end
  
  def updaterole
    #current_user = User.first #remark
    feature_masters = FeatureMaster.all.order(:content)
    role_master = RoleMaster.find(updaterole_params['role_master_id'])
    roletransactions = check_box_bug(updaterole_params['roletransaction'])
    counter = 0
    feature_masters.each do |feature_master|
      
      active = false
      if roletransactions[counter] == 1 
        active = true
      end
      
      role_transaction = RoleTransaction.where("role_master_id=? AND feature_master_id=?", role_master.id, feature_master.id).first
      if role_transaction
        if role_transaction.active != active 
          role_transaction.update(active: active, user_id: current_user.id)
        end  
      else
        RoleTransaction.create!(role_master_id: role_master.id, feature_master_id: feature_master.id, user_id: current_user.id, active: active)
      end
      counter += 1  
    end
    
    flash[:success] = "Featureγη·¨ιγγΎγγ"
    redirect_to role_masters_path
  end

  private

  def role_master_params
    params.require(:role_master).permit(:content, :abrev, :description)
  end

  def updaterole_params
    params.require(:updaterole).permit(:role_master_id, :roletransaction=>[])
  end

  def check_box_bug(param_checkbox)
    count_array=0
    result={}
    (0..param_checkbox.count-1).each do |i|
      if param_checkbox[i]=='1'
        count_array -= 1
        result[count_array]=1
        count_array += 1
      else
        result[count_array]=0
        count_array += 1
      end
    end
    return result
  end

  def correct_user
    allowed = false
    if current_user.admin 
      allowed = true
    end
    
    roles = current_user.role_users 
    roles.each do |role|
      if role.active?
        role_master = RoleMaster.find(role.role_master_id)
        role_master.role_transactions.each do |role_transaction|
          if role_transaction.active?
            feature_master = FeatureMaster.find(role_transaction.feature_master_id)
            if feature_master.abrev == "00001"
              allowed = true   
            end
          end
        end
      end
    end

    if allowed != true
      redirect_to(root_url)  
    end
  end
end

