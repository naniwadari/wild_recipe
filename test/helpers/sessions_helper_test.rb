require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  #リメンバーメソッドで@userのリメンバーを保存
  def setup
    @user = users(:recipeman)
    remember(@user)
  end
  
  #リメンバー情報がある場合、正しくログインできていることを確認
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  #リメンバー情報が違う場合,current_userがnilであることを確認
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute((:remember_digest), User.digest(User.new_token))
    assert_nil current_user
  end
end