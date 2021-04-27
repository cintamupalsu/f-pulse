class ApisController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def mujin_buy
        email = mujintransaction_params['email']
        apikey = mujintransaction_params['apikey']
        mujin_item_id = mujintransaction_params['mujinitemid']
        pieces = mujintransaction_params['pieces']
        # authorization
        
    end

    def mujin_stock
    end

    private
    # params
    def mujintransaction_params
        params.permit(:email, :apikey, :mujinitemid, :pieces)
    end

end
