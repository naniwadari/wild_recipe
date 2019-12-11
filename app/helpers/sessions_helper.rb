module SessionsHelper
  
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #渡されたユーザーがログインしているユーザーと一致していればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  #現在ログイン中のユーザーを返す（いる場合)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  #ユーザーがログインしていればtrue,その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  #セッションを削除しユーザーをログアウトさせる
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  #記憶したURL or デフォルトURLにリダイレクト、その後セッション情報を削除
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default )
    session.delete(:forwarding_url)
  end
  
  #アクセスしようとしたURLを記憶
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
