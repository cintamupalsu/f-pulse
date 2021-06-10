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
        
        if user && user.remember_digest && user.authenticated?(token)
            jsonMsg(200,"Authenticated",[user.full_name]) 
        else
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def mujin_points
        email = params[:email]
        token = params[:token]
        if token_authentication(email, token)
            mujins = Mujin.all
            jsonMsg(200,"Mujin Data", mujins)
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

 

    private
    # params
    def mujintransaction_params
        params.permit(:email, :apikey, :mujinitemid, :pieces)
    end

    def jsonMsg(errNum, errMessage, results)
        responseInfo = {status: errNum, developerMessage: errMessage}
        metadata = {responseInfo: responseInfo}
        jsonString = {metadata: metadata, results: results}
        render json: jsonString.to_json
    end

    def token_authentication(email, token)
        user = User.find_by(email: email)
        if user && user.remember_digest && user.authenticated?(token)
            return true
        end
        return false
    end
end
