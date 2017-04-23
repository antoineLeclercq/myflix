class CategoriesController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by_token(params[:id])
  end
end
