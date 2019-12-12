class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  #SecurityEroorが起きた場合のアクション
  rescue_from SecurityError do |exception|
    redirect_to root_path
    flash[:danger] = "アクセス権限がありません"
  end
  
  protected
  
  #active_admin、adminユーザー以外が管理画面にアクセスするとSecurityErrorを吐き出す
  def authenticate_admin_user!
    if current_user.nil?
      redirect_to root_path
      flash[:danger] = "ログインしてください"
    elsif current_user.admin? == false
      raise SecurityError
    end
  end
  
end
