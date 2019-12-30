class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit]
  before_action :correct_user, only:[:edit, :update, :release, :destroy]
  def index
    @recipes = Recipe.where(release: true).page(params[:page])
  end
  
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
    @user = User.find_by(id: @recipe.user_id)
    @ingredients = IngredientCollection.new( [], @recipe.id)
    @procedure = @recipe.procedure.build
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(recipe_params)
      redirect_to edit_recipe_path(@recipe)
    else
      render "edit"
    end
  end
  
  #@recipe,@userはcorrect_userで設定
  def destroy
    @recipe.destroy
    flash[:success] = "レシピを削除しました"
    redirect_to user_path(@user)
  end
  
  def release
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(release: params[:release])
      if @recipe.release == true
        flash[:success] = "レシピを公開しました"
        redirect_to recipe_path(@recipe)
      else
        flash[:success] = "レシピを下書きにしました"
        redirect_to user_path(id: @recipe.user_id)
      end
    else
      render "edit"
    end
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
        flash[:danger] = "レシピの閲覧・投稿・編集にはログインが必要です。"
        redirect_to login_url
      end
    end
    
    #レシピＩＤからユーザーを抽出して@recipe_authorに代入
    def recipe_author
      @recipe = Recipe.find_by(id: params[:id])
      @user = User.find_by(id: @recipe.user_id) if @recipe.present?
    end
    
    #レシピの執筆者とログインユーザーが同じ場合を検証
    def correct_user
      recipe_author
      redirect_to(root_url) unless current_user?(@user)
    end
end
