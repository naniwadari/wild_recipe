class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    #userがadminなら管理画面へリダイレクト
    if @user && @user.authenticate(params[:session][:password]) && @user.admin?
      log_in @user
      redirect_to admin_root_path
    elsif @user && @user.authenticate(params[:session][:password])
      log_in @user
      #チェックボックスがオンなら永続セッションを保存、オフなら削除
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      flash[:success] = "ログインしました"
      redirect_back_or root_url
    elsif
      flash.now[:danger] = "ログインに失敗しました"
      render "new"
    end
  end
  
  def twitter_create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    session[:user_id] = @user.id
    flash[:notice] = "ユーザー認証が完了しました"
    redirect_back_or root_url
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_url
  end
end
