class TypesController < ApplicationController
  def index
    @types = Type.all
  end

  def new
    @type = Type.new
  end

  def edit
    @type = Type.find(params[:id])
  end

  def update
    @type = Type.find(params[:id])

    if @type.update_attributes(params[:type])
      flash[:notice] = 'Type was successfully updated.'
      redirect_to(types_path)
    else
      render :action => "edit"
    end
  end

  def create
    @type = Type.new(params[:type])

    if @type.save
      flash[:notice] = 'Your type was successfully created.'
      redirect_to(types_path)
    else
      render :action => "new"
    end
  end

  def destroy
    @type = Type.find(params[:id])
    @type.destroy

    redirect_to(types_path)
  end
end
