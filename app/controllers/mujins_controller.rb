class MujinsController < ApplicationController
    before_action :authenticate_user!  #unremark
    
    def show #Mujin dashboard
       
    end

    def management
        #current_user = User.first #remark😀
        @mujins = current_user.mujins
    end
    
    def map
    end
end
