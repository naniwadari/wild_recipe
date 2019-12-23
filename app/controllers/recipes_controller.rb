class RecipesController < ApplicationController
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to edit_recipe_path(@recipe)
    else
      render "new"
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    @ingredients = IngredientCollection.new( [], @recipe.id)
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  private
  
  #Recipeのストロングパラメーター
  def recipe_params
    params.require(:recipe).permit(:name, :user_id, :comment)
  end
  
end
