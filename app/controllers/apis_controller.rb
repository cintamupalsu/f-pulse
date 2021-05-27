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
    
    def scan
        email = params[:email]
        token = params[:token]
        user = User.find_by(email: email)
        
        if user && user.authenticated?(token)
            jsonMsg(200,"Authenticated",[1,2,3,4]) 
        else
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    private
    # params
    def mujintransaction_params
        params.permit(:email, :apikey, :mujinitemid, :pieces)
    end

    def jsonMsg(errNum, errMessage, result)
        responseInfo = {status: errNum, developerMessage: errMessage}
        metadata = {responseInfo: responseInfo}
        jsonString = {metadata: metadata, result: result}
        render json: jsonString.to_json
    end
end
