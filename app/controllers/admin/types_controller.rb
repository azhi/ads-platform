class Admin::TypesController < Admin::AdminController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def edit
  end

  def update
    if @type.update_attributes(params[:type])
      flash[:notice] = 'Type was successfully updated.'
      redirect_to(admin_types_path)
    else
      render :action => "edit"
    end
  end

  def create
    if @type.save
      flash[:notice] = 'Your type was successfully created.'
      redirect_to(admin_types_path)
    else
      render :action => "new"
    end
  end

  def destroy
    @type.destroy

    redirect_to(admin_types_path)
  end
end
