class MujinsController < ApplicationController
    before_action :authenticate_user!  #unremark
    
    def mgmt #Mujin dashboard
        
    end

    def show 
        @mujin = Mujin.find(params[:id])

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
        @mujin.image.attach(params[:mujin][:image])
        
        # convert experiment
        #sample = open(params[:mujin][:image]) { |f| f.read }
        #@sample64 = Base64.strict_encode64(sample)
        data = params[:mujin][:image]
        #data = @mujin.display_image
        File.open(data, 'rb') do |img|
            @sample64 = 'data:image/jpg;base64,' + Base64.strict_encode64(img.read)
            #@sample64 = Base64.strict_encode64(img.read)
        end
        img_from_base64 = Base64.decode64(@sample64)
        @sampleImage = img_from_base64
        # end of convert experiment
        @mujin.image64 = @sample64
        
        if @mujin.save
          flash[:success]= "👩🏻‍💼"+@mujin.name+"を登録しました。"
          #redirect_to mujins_path
          render 'imagetest'
        else
          render 'new'
        end
    end

    def edit
        @mujin = Mujin.find(params[:id])
    end

    def update
        @mujin = Mujin.find(params[:id])

        data = params[:mujin][:image]
        File.open(data, 'rb') do |img|
            @mujin.image64 = 'data:image/jpg;base64,' + Base64.strict_encode64(img.read)
        end
        
        if @mujin.update(mujin_params)
          flash[:success]= @mujin.name + "を編集しました"
          redirect_to mujins_path
        else
          render 'edit'
        end
    end
    
    def destroy
        #mujin = Mujin.find(params[:id])
        #mujin.mujin_items.destroy_all
        #mujin.destroy
        Mujin.find(params[:id]).destroy
        flash[:success] = "無人販売を削除しました。"
        redirect_to mujins_path
    end

    private 
    
    def mujin_params
        params.require(:mujin).permit(:name, :lat, :lon, :user_id, :content, :image)
    end

end
