class Admin::CategoryController < ApplicationController
  before_action :set_category, only: [:update, :destroy, :edit]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
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
    if @category.update(category_params)
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
      flash[:alert] = 'Failed because thie category used by item.'
      redirect_to category_index_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end