class MujinItemsController < ApplicationController
  def index
  end
  
  def new
    @mujin_item = MujinItem.new
    @mujin = Mujin.find(params[:id])
  end

  def create
    @mujin_item = MujinItem.new(mujin_item_params)
    if @mujin_item.save
      flash[:success]= "👩🏻‍💼"+@mujin_item.name+"を登録しました。"
      redirect_to mujin_path(:id => @mujin_item.mujin_id)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    @mujin_item = MujinItem.find(params[:id])
    @mujin = Mujin.find(@mujin_item.mujin_id)
  end

  def update
    @mujin_item = MujinItem.find(params[:id])
    if @mujin_item.update(mujin_item_params)
      flash[:success]= "無人項目を編集しました"
      redirect_to mujin_path(:id => @mujin_item.mujin_id)
    else
      render 'edit'
    end
  end

  def destroy
    mujin_id = MujinItem.find(params[:id]).mujin_id
    MujinItem.find(params[:id]).destroy
    flash[:success] = "無人項目を削除しました。"
    redirect_to mujin_path(:id => mujin_id)
  end

  private 
    
    def mujin_item_params
        params.require(:mujin_item).permit(:name, :stock, :price, :mujin_id)
    end


end
