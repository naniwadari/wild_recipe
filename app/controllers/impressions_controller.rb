class ImpressionsController < ApplicationController
  
  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    current_user.write_comment(@recipe, params[:comment])
    redirect_to @recipe
  end
  
  def destroy
    @comment = Impression.find_by(id: params[:id])
    @recipe = @comment.recipe
    @comment.destroy
    redirect_to @recipe
  end

end
