class Admin::CategoryController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_category, only: [:update, :destroy, :edit]

  def index
    @categories = Category.where.not(sort: nil).order(sort: :asc).page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(set_params)
    # @last_category_sort = Category.maximum(:sort) || 0
    # @category.sort = @last_category_sort + 1
    if @category.save
      flash[:notice] = 'Success'
      redirect_to category_index_path
    else
      flash[:alert] = 'Failed'
      render :new
    end
  end

  def edit;end

  def update
    if @category.update(set_params)
      flash[:notice] = 'Update Successful'
      redirect_to category_index_path
    else
      flash[:alert] = 'Update Failed'
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = 'Delete Success'
      redirect_to category_index_path
    else
      flash[:alert] = 'Failed because the category used by items.'
      redirect_to category_index_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_params
    params.require(:category).permit(:name, :sort)
  end
end