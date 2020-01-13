class BooksController < ApplicationController
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.book(@recipe)
    respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end
  
  def destroy
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.unbook(@recipe)
    respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end
end
