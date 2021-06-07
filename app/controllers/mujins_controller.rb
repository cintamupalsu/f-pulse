class MujinsController < ApplicationController
    before_action :authenticate_user!  #unremark
    
    def mgmt #Mujin dashboard
        
    end

    def index
        #current_user = User.first #remark😀
        @mujins = current_user.mujins
    end
    
    def map
    end

    def new 
        @mujin = Mujin.new
    end

    def create
        @mujin = Mujin.new(mujin_params)
        if @mujin.save
          flash[:success]= "👩🏻‍💼"+@mujin.name+"を登録しました。"
          redirect_to mujins_path
        else
          render 'new'
        end
    end

    private 
    
    def mujin_params
        params.require(:mujin).permit(:name, :lat, :lon, :user_id)
    end

end
