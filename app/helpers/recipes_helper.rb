module RecipesHelper
  
    #ログイン済ユーザーかどうか確認
    def logged_in_author
      unless logged_in?
        store_location
        flash[:danger] = "レシピの閲覧・投稿・編集にはログインが必要です。"
        redirect_to login_url
      end
    end
    
    #URLからレシピＩＤを取得。
    def recipe_author
      @recipe = Recipe.find_by(id: params[:id])
      @user = User.find_by(id: @recipe.user_id) if @recipe.present?
    end
    
    #フォームのパラメーターからレシピIDを取得
    def recipe_author_via
      @recipe = Recipe.find_by(id: params[:recipe_id])
      @user = User.find_by(id: @recipe.user_id) if @recipe.present?
    end
    
    #recipe_authorメソッドでユーザー情報を取得
    def correct_author
      recipe_author
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #recipe_author_viaメソッドでユーザー情報を取得
    def correct_author_via
      recipe_author_via
      redirect_to(root_url) unless current_user?(@user)
    end
end
