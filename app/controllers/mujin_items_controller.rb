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
      flash[:success]= "๐ฉ๐ปโ๐ผ"+@mujin_item.name+"ใ็ป้ฒใใพใใใ"
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
      flash[:success]= "็กไบบ้ ็ฎใ็ทจ้ใใพใใ"
      redirect_to mujin_path(:id => @mujin_item.mujin_id)
    else
      render 'edit'
    end
  end

  def destroy
    mujin_id = MujinItem.find(params[:id]).mujin_id
    MujinItem.find(params[:id]).destroy
    flash[:success] = "็กไบบ้ ็ฎใๅ้คใใพใใใ"
    redirect_to mujin_path(:id => mujin_id)
  end

  private 
    
    def mujin_item_params
        params.require(:mujin_item).permit(:name, :stock, :price, :mujin_id)
    end


end
