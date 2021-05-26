class DashboardsController < ApplicationController
  before_action :authenticate_user!  #unremark
  # before_action :correct_user, only: [:user_index, :user_role, :updateuserrole, :updatesubfeatureuser] #unremark
  # before_action :maintenance_user, only: [:masters_maintenance, :updatesubfeatureuser]
  

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

  def user_index
    @users = User.all
  end

  def user_role
    @user = User.find(params[:id])
    @role_masters = RoleMaster.all.order(:content)
  end

  def updateuserrole
    user = User.find(updateuserrole_params['user_id'])
    role_master_ids = updateuserrole_params['role_master_id']
    checks = check_box_bug(updateuserrole_params['roleuser'])
   

    counter = 0
    subcounter = 0
    role_master_ids.each do |role_master_id|

      active = false
      if checks[counter] == 1 
        active = true
      end
      
      role_user = RoleUser.where('role_master_id=? AND user_id=?', role_master_id, user.id).first
    
      if role_user
        if role_user.active != active 
          role_user.update(active: active)
        end  
      else
        RoleUser.create!(role_master_id: role_master_id, user_id: user.id, active: active)
      end
      
      #role_master = RoleMaster.find(role_master_id)
      #role_master.role_transactions.each do |role_transaction|
      #  feature_master = FeatureMaster.find(role_transaction.feature_master_id)
      #  feature_master.sub_feature_masters.each do |sub_feature_master|
      #    sub_feature_user = SubFeatureUser.where("user_id = ? AND sub_feature_master_id = ?", user.id, sub_feature_master.id).first
      #    if subfeatureuserchecks[subcounter] == 1
      #      if sub_feature_user
      #        if sub_feature_user.active == false
      #          
      #          sub_feature_user.update(active: true)
      #        
      #        end
      #      else
      #        SubFeatureUser.create!(user_id: user.id, sub_feature_master_id: sub_feature_master.id, active: true)
      #      end
      #    else
      #      if sub_feature_user 
      #        if sub_feature_user.active == true
      #          sub_feature_user.update(active: false)
     # 
     #         end
     #       else
     #         SubFeatureUser.create!(user_id: user.id, sub_feature_master_id: sub_feature_master.id, active: false)
     #       end
      #    end
      #    subcounter += 1
      #  end
      #end
      
      counter += 1  
    end
    
    flash[:success] = "Roleを編集しました"
    redirect_to user_index_path
  end

  def user_feature_roles
    @user = User.find(params['selected_user_id'])
    @role_master = RoleMaster.find(params['role_master_id'])
  end

  def updatesubfeatureuser
    user = User.find(updatesubfeatureuser_params['user_id'])
    sub_feature_master_ids = updatesubfeatureuser_params['sub_feature_master_ids']
    sub_feature_user_ids = updatesubfeatureuser_params['sub_feature_user_ids']
    subfeatureuserchecks = check_box_bug(updatesubfeatureuser_params['subfeatureuserchecks'])
    sfmarray = 0
    sub_feature_master_ids.each do |sub_feature_master_id|
      if sub_feature_user_ids[sfmarray] != -1 
        sub_feature_user = SubFeatureUser.find(sub_feature_user_ids[sfmarray])
        if subfeatureuserchecks[sfmarray] != sub_feature_user.active
          
          sub_feature_user.update(active: subfeatureuserchecks[sfmarray])
        end
      else
        if subfeatureuserchecks[sfmarray] == 1
          SubFeatureUser.create!(user_id: user.id, sub_feature_master_id: sub_feature_master_id, active: true)
        else
          SubFeatureUser.create!(user_id: user.id, sub_feature_master_id: sub_feature_master_id, active: false)
        end
      end
      sfmarray += 1
    end
    redirect_to user_role_path(:id => user.id)
  end
  
  private 
    
    def updateuserrole_params
      params.require(:updateuserrole).permit(:user_id, :role_master_id=>[], :roleuser=>[])
    end

    def updatesubfeatureuser_params
      params.require(:updatesubfeatureuser).permit(:user_id, :sub_feature_master_ids=> [], :sub_feature_user_ids=>[], :subfeatureuserchecks=>[])
    end

    def maintenance_user 
      #current_user = User.first #remark
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
              if feature_master.master?
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
    
    def correct_user
      #current_user = User.first #remark
      
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
              if feature_master.abrev == "00002"
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
end