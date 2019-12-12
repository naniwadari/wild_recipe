class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) && user.admin?
      log_in user
      redirect_to admin_root_path
    elsif user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or user
    elsif
      flash.now[:danger] = "ログインに失敗しました"
      render "new"
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
