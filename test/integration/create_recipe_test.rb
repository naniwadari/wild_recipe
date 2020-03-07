require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:recipeman)
  end
  
    
  #未ログインで行こうとすると失敗
  test "create recipe should require login" do
    get new_recipe_path
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  #レシピ名前入力成功時
  test "successful_new_recipe" do
    log_in_as(@user)
    get new_recipe_path
    assert_template "recipes/new"
    recipe_name = "スベリヒユのおひたし"
    assert_difference "Recipe.count",1 do
      post recipes_path, params:{ recipe: { name: recipe_name }}
    end
    follow_redirect!
    assert_template "recipes/edit"
  end

  #空白で投稿すると失敗
  test "unsuccessful_new_recipe" do
    log_in_as(@user)
    get new_recipe_path
    recipe_name = ""
    assert_no_difference "Recipe.count" do
      post recipes_path, params:{ recipe: { name: recipe_name }}
    end
    assert_template "recipes/new"
  end
end
