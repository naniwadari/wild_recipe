require 'test_helper'

class ImpressionTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @recipe = recipes(:suberihiyu)
  end
  
  #コメント成功パターン
  test "successful comment" do
    log_in_as(@user)
    get recipe_path(@recipe)
    comment = "sample comment"
    assert_difference "Impression.count", 1 do
      post impressions_path, params: { recipe_id: @recipe.id,
                                       comment: comment }
    end
  end
end
