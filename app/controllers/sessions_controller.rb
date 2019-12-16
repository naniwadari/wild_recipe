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
      redirect_back_or @user
    elsif
      flash.now[:danger] = "ログインに失敗しました"
      render "new"
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
