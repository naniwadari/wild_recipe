require 'test_helper'

class LikeFunctionTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @other_user = users(:recipewoman)
    @recipe = recipes(:suberihiyu)
  end
  
  #イイネとイイネ取り消し成功
  test "successful like and unlike" do
    log_in_as(@user)
    get recipe_path(@recipe)
    #イイネボタン
    assert_select "form[action=?]","/likes"
    #イイネ件数表示が無い
    assert_select "a[href=?]", liked_recipe_path(@recipe), count: 0
    #データ送信
    assert_difference "Like.count", 1 do
      post likes_path, params:{ recipe_id: @recipe.id }, xhr: true
    end
    #1イイネの表示があるかどうか
    like_count = @recipe.likes.count
    assert_match "#{like_count}イイネ", response.body
    #ページをリロード
    get recipe_path(@recipe)
    #イイネ解除ボタン
    assert_select "form[action=?]", "/likes/#{(Like.last.id)}"
    #イイネ件数表示がある
    assert_select "a[href=?]", liked_recipe_path(@recipe)
    #解除データ送信
    assert_difference "Like.count", -1 do
      delete like_path(@user.likes.find_by(recipe_id: @recipe.id)),
             params:{ recipe_id: @recipe.id }
    end
  end
  
  #イイネしたユーザーが表示されているか
  test "liked_view should show liked_user" do
    @user.like(@recipe)
    @other_user.like(@recipe)
    log_in_as(@other_user)
    get liked_recipe_path(@recipe)
    @recipe.likes.each do |like|
      liked_user = User.find_by(id: like.user_id)
      assert_select "a[href=?]", user_path(liked_user), text: liked_user.name
    end
  end
end
