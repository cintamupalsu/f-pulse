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
            
            jsonMujins = []
            counter = 0
            mujins.each do |mujin|
                jsonMujin = {}
                jsonMujin["id"] = mujin.id
                jsonMujin["name"] = mujin.name
                jsonMujin["lat"] = mujin.lat
                jsonMujin["lon"] = mujin.lon
                jsonMujin["user_id"] = mujin.user_id
                jsonMujin["content"] = mujin.content
                if mujin.image64 == nil 
                    #jsonMujin["image64"] = ""
                else
                    #jsonMujin["image64"] = mujin.image64
                end
                jsonMujinItems = []
                subcounter = 0
                mujin.mujin_items.each do | mujin_item |
                    jsonMujinItem = {}
                    jsonMujinItem["id"] = mujin_item.id
                    jsonMujinItem["name"] = mujin_item.name
                    jsonMujinItem["stock"] = mujin_item.stock
                    jsonMujinItem["price"] = mujin_item.price
                    jsonMujinItems[subcounter] = jsonMujinItem
                    subcounter += 1
                end
                jsonMujin["mujin_items"] = jsonMujinItems

                jsonMujins[counter] = jsonMujin
                counter += 1
            end
            
            jsonString = {mujins: jsonMujins}
            render json: jsonString.to_json
            #jsonMsg(200,"Mujin Data", mujins)
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def user_mujins
        email = params[:email]
        token = params[:token]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            mujins = user.mujins

            jsonMujins = []
            counter = 0
            mujins.each do |mujin|
                jsonMujin = {}
                jsonMujin["id"] = mujin.id
                jsonMujin["name"] = mujin.name
                jsonMujin["lat"] = mujin.lat
                jsonMujin["lon"] = mujin.lon
                jsonMujin["user_id"] = mujin.user_id
                jsonMujin["content"] = mujin.content
                
                jsonMujinItems = []
                subcounter = 0
                mujin.mujin_items.each do | mujin_item |
                    jsonMujinItem = {}
                    jsonMujinItem["id"] = mujin_item.id
                    jsonMujinItem["name"] = mujin_item.name
                    jsonMujinItem["stock"] = mujin_item.stock
                    jsonMujinItem["price"] = mujin_item.price
                    jsonMujinItems[subcounter] = jsonMujinItem
                    subcounter += 1
                end
                jsonMujin["mujin_items"] = jsonMujinItems

                jsonMujins[counter] = jsonMujin
                counter += 1
            end
            
            jsonString = {mujins: jsonMujins}
            render json: jsonString.to_json
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def create_mujin
        email = params[:email]
        token = params[:token]
        name = params[:name]
        content = params[:content]
        lat = params[:lat]
        lon = params[:lon]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            Mujin.create(name: name, lat: lat.to_f, lon: lon.to_f, user_id: user.id, content: content)
            
            mujins = user.mujins.order(:created_at)
            jsonMujins = []
            counter = 0
            mujins.each do |mujin|
                jsonMujin = {}
                jsonMujin["id"] = mujin.id
                jsonMujin["name"] = mujin.name
                jsonMujin["lat"] = mujin.lat
                jsonMujin["lon"] = mujin.lon
                jsonMujin["user_id"] = mujin.user_id
                jsonMujin["content"] = mujin.content
                
                jsonMujinItems = []
                subcounter = 0
                mujin.mujin_items.each do | mujin_item |
                    jsonMujinItem = {}
                    jsonMujinItem["id"] = mujin_item.id
                    jsonMujinItem["name"] = mujin_item.name
                    jsonMujinItem["stock"] = mujin_item.stock
                    jsonMujinItem["price"] = mujin_item.price
                    jsonMujinItems[subcounter] = jsonMujinItem
                    subcounter += 1
                end
                jsonMujin["mujin_items"] = jsonMujinItems

                jsonMujins[counter] = jsonMujin
                counter += 1
            end
            
            jsonString = {mujins: jsonMujins}
            render json: jsonString.to_json
            #jsonMsg(201,"Mujin Created",[])
        else
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def edit_mujin
        email = params[:email]
        token = params[:token]
        name = params[:name]
        content = params[:content]
        lat = params[:lat]
        lon = params[:lon]
        mujin_id = params[:mujin_id]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            mujin = Mujin.find(mujin_id)
            if mujin.user_id == user.id 
                mujin.update(name: name, content: content, lat: lat, lon: lon)
            end
            jsonMsg(200,"Mujin updated",[user.full_name]) 
        else
            jsonMsg(500,"Authentication failed",[]) 
        end
    end

    def delete_mujin
        email = params[:email]
        token = params[:token]
        mujin_id = params[:mujin_id]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            mujin = Mujin.find(mujin_id)
            if user.id == mujin.user_id
                mujin.destroy
            end
            jsonMsg(200,"Mujin deleted",[user.full_name])
        else
            jsonMsg(500,"Authentication failed",[])
        end
    end

    def get_mujin_image
        email = params[:email]
        token = params[:token]
        if token_authentication(email, token)
            mujin = Mujin.find(params[:mujin_id])
            if mujin.image64 != nil
                jsonString = {image64: mujin.image64}
            else
                jsonString = {image64: ""} 
            end
            render json: jsonString.to_json
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def update_mujin_image
        email = params[:email]
        token = params[:token]
        if token_authentication(email, token)
            mujin = Mujin.find(params[:mujin_id])
            image64 = Base64.decode64(params[:image64])
            mujin.update(image64: image64)
            jsonMsg(200,"Mujin image updated",[]) 
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def create_mujin_item
        email = params[:email]
        token = params[:token]
        name = params[:name]
        stock = params[:stock].to_f
        price = params[:price].to_f
        mujin_id = params[:mujin_id].to_i
        if token_authentication(email, token)
            user = User.find_by(email: email)
            #mujin = Mujin.find(mujin_id)
            #mujin.mujin_items.create(name: name, stock: stock, price: price)
            MujinItem.create(name: name, stock: stock, price: price, mujin_id: mujin_id)
            mujins = user.mujins.order(:created_at)
            jsonMujins = []
            counter = 0
            mujins.each do |mujin|
                jsonMujin = {}
                jsonMujin["id"] = mujin.id
                jsonMujin["name"] = mujin.name
                jsonMujin["lat"] = mujin.lat
                jsonMujin["lon"] = mujin.lon
                jsonMujin["user_id"] = mujin.user_id
                jsonMujin["content"] = mujin.content
                
                jsonMujinItems = []
                subcounter = 0
                mujin.mujin_items.each do | mujin_item |
                    jsonMujinItem = {}
                    jsonMujinItem["id"] = mujin_item.id
                    jsonMujinItem["name"] = mujin_item.name
                    jsonMujinItem["stock"] = mujin_item.stock
                    jsonMujinItem["price"] = mujin_item.price
                    jsonMujinItems[subcounter] = jsonMujinItem
                    subcounter += 1
                end
                jsonMujin["mujin_items"] = jsonMujinItems
                jsonMujins[counter] = jsonMujin
                counter += 1
            end
            jsonString = {mujins: jsonMujins}
            render json: jsonString.to_json
        else 
            jsonMsg(501,"Authentication Failed",[])
        end
    end

    def edit_mujin_item
        email = params[:email]
        token = params[:token]
        name = params[:name]
        stock = params[:stock]
        price = params[:price]
        mujin_item_id = params[:mujin_item_id]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            mujin_item = MujinItem.find(mujin_item_id)
            mujin = Mujin.find(mujin_item.mujin_id)
            if mujin.user_id == user.id 
                mujin_item.update(name: name, stock: stock, price: price)
            end
            jsonMsg(200,"Mujin item updated",[user.full_name]) 
        else
            jsonMsg(500,"Authentication failed",[]) 
        end
    end

    def delete_mujin_item
        email = params[:email]
        token = params[:token]
        mujin_item_id = params[:mujin_item_id]
        if token_authentication(email, token)
            user = User.find_by(email: email)
            mujin_item = MujinItem.find(mujin_item_id)
            mujin = Mujin.find(mujin_item.mujin_id)
            if user.id == mujin.user_id
                mujin_item.destroy
            end
            jsonMsg(200,"Mujin item deleted",[user.full_name])
        else
            jsonMsg(500,"Authentication failed",[])
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
