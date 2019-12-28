require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @recipe = recipes(:suberihiyu)
    @input_ingredients = [ {name: "スベリヒユ", amount: "100g"},
                             {name: "ポン酢", amount: "大匙3"},
                             {name: "七味", amount: "少々"}]
    @input_ingredients_alt = [ {name: "", amount: ""},
                               {name: "", amount: ""},
                               {name: "スベリヒユ", amount: "200g"}]
    @ingredient_num = IngredientCollection::INGREDIENT_NUM
  end
  
  #未ログインは弾かれる
  test "recipe-edit should require login" do
    get edit_recipe_path(@recipe)
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  #材料入力成功
  test "success edit ingredients" do
    log_in_as(@user)
    get edit_recipe_path(@recipe)
    assert_template "recipes/edit"
    #一回目のデータ投下
    assert_difference "Ingredient.count", @ingredient_num do
      post ingredients_path, params:{ ingredients: @input_ingredients,
                                      recipe_id: @recipe.id }
    end
    #データの照会
    assert_equal @recipe.ingredient.find_by(number: "1").name, @input_ingredients[0][:name]
    assert_equal @recipe.ingredient.find_by(number: "2").name, @input_ingredients[1][:name]
    assert_equal @recipe.ingredient.find_by(number: "3").name, @input_ingredients[2][:name]
    assert_nil @recipe.ingredient.find_by(number: "4").name
    assert_nil @recipe.ingredient.find_by(number: "5").name
    #2回目のデータ投下
    assert_no_difference "Ingredient.count" do
      post ingredients_path, params:{ ingredients: @input_ingredients_alt,
                                      recipe_id: @recipe.id }
      end
    #空白のデータは登録されていない+順番がちゃんと整列されていることの確認
    assert_equal @recipe.ingredient.find_by(number: "1").name, @input_ingredients_alt[2][:name]
    assert_nil @recipe.ingredient.find_by(number: "2").name
    assert_nil @recipe.ingredient.find_by(number: "3").name
    assert_nil @recipe.ingredient.find_by(number: "4").name
    assert_nil @recipe.ingredient.find_by(number: "5").name
  end
  
end
