class LikesController < ApplicationController
  
  def create
    recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.like(recipe)
    redirect_to recipe
  end
  
  def destroy
    recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.unlike(recipe)
    redirect_to recipe
  end
end
