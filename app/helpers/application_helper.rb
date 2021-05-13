module ApplicationHelper
   
    #Returns the full title on a per-page basis.
    def full_title(page_title = '')
        base_title = "E-I-E-I-農🎵🎶Project"
        if page_title.empty?
            base_title
        else
            page_title + " 🌾 " + base_title
        end
    end

    #Maintenace User
    def maintenance_user
        
        #current_user = User.first #remark
        roles = current_user.role_users 
        roles.each do |role|
            if role.active?
                role_master = RoleMaster.find(role.role_master_id)
                role_master.role_transactions.each do |role_transaction|
                    if role_transaction.active?
                        feature_master = FeatureMaster.find(role_transaction.feature_master_id)
                        if feature_master.master?
                            return true   
                        end
                    end
                end
            end
        end
        return false
    end
    
end
