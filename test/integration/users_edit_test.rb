require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @other_user = users(:recipewoman)
  end
  
  #プロフィール変更へ無効なデータを送信
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@inbalid",
                                              password: "foo",
                                              password_confirmation: "bar"}}
    assert_template "users/edit"
    assert_select "div.alert"
  end
  
  #プロフィール変更へ有効なデータを送信
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "Patch Man"
    email = "foo@valid.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: ""}}
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  #プロフィールテキストの追加テスト
  test "successful edit profile_text" do
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    #折り畳みの変更ボタンが表示されていることの確認
    assert_select "a", text: "ユーザー情報の変更"
    profile_text = "テスト文章です"
    patch user_path(@user), params: { user: { profile_text: profile_text }}
    assert_redirected_to @user
    @user.reload
    assert_equal profile_text, @user.profile_text
  end
  
  #正規ユーザー以外には変更ボタンを表示しない
  test "change-button should only appear right user" do
    log_in_as(@other_user)
    get user_path(@user)
    assert_template "users/show"
    assert_select "a", text: "変更", count: 0
  end
  
  #フレンドリーフォワーディングのテスト
  test "friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwading_url]
    assert_redirected_to edit_user_url(@user)
  end
end
