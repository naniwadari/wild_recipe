require 'test_helper'

class UserCommentTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @other_user = users(:recipewoman)
    @recipe = recipes(:suberihiyu)
    @comment = impressions(:test_comment)
  end

  #コメントの成功
  test "successful comment" do
    log_in_as(@user)
    get recipe_path(@recipe)
    assert_difference "Impression.count", 1 do
      post impressions_path, params:{ recipe_id: @recipe.id,
                                      comment: "テストコメント"}
    end
    get recipe_path(@recipe)
    comment = Impression.last
    #コメントが表示されているか
    assert_match comment.comment, response.body
    #コメントを書いたユーザーに削除リンクが表示されているか
    assert_select "a[href=?]", impression_path(comment)
    log_in_as(@other_user)
    get recipe_path(@recipe)
    #別のユーザーでは削除リンクが表示されない
    assert_select "a[href=?]", impression_path(comment), 0
    log_in_as(@user)
    assert_difference "Impression.count", -1 do
      delete impression_path(comment)
    end
  end

  #コメントは別のユーザーには削除されない
  test "comment-delete should require correct-user" do
    log_in_as(@other_user)
    assert_no_difference "Impression.count" do
      delete impression_path(@comment)
    end
    assert_redirected_to root_url
    assert_not flash.empty?
  end
end
