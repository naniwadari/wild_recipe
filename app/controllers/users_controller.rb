class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user.present?
      @recipes = @user.recipes.where(release: true).order(id: "desc").page(params[:page]).per(10)
      @draft_recipes = @user.recipes.where(release: false).order(id: "desc").page(params[:draft_page]).per(10)
      @like_recipes = @user.likes.order(id: "desc").page(params[:like_page]).per(10)
    else
      flash[:danger] = "ユーザーが見つかりませんでした"
      redirect_to root_url
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "WildRecipeへようこそ！"
      redirect_to @user
    else
      render "new"
    end
  end
  
  #@userはbefore_actionのcorrect_userで定義
  def edit
  end
  
  #@userはbefore_actionのcorrect_userで定義
  def update
    if @user.update_attributes(user_params)
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
    else
      render "edit"
    end
  end

  private
    
    #このparamsハッシュでは:user属性を必須とし、許可した属性以外をブロックする(strong parameters)
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,:profile_text)
    end
    
    #beforeアクション
    
    #ログイン済ユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
