class LikesController < ApplicationController
  before_action :logged_in_user
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.like(@recipe)
    respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end
  
  def destroy
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.unlike(@recipe)
    respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end

  private
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
  
end