class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit]
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to edit_recipe_path(@recipe)
    else
      flash[:danger] = "レシピ名を入力してください"
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
      params.require(:recipe).permit(:name, :comment)
    end
    
   #ログイン済ユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "レシピ投稿・編集にはログインが必要です。"
        redirect_to login_url
      end
    end
    
end
