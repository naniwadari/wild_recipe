require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:recipeman)
    @other_user = users(:recipewoman)
    @recipe = recipes(:suberihiyu)
    @input_ingredients = [ {name: "スベリヒユ", amount: "100g"},
                             {name: "ポン酢", amount: "大匙3"},
                             {name: "七味", amount: "少々"}]
    @input_ingredients_alt = [ {name: "", amount: ""},
                               {name: "", amount: ""},
                               {name: "スベリヒユ", amount: "200g"}]
    #材料データの個数、IngredientCollectionを参照
    @ingredient_num = IngredientCollection::INGREDIENT_NUM
    #手順データ2個
    @procedure = procedures(:procedure_1)
    @procedure_alt = procedures(:procedure_2)
  end
  
  #未ログインは弾かれる
  test "recipe-edit should require login" do
    get edit_recipe_path(@recipe)
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  #レシピ削除成功
  test "successful delete recipe" do
    log_in_as(@user)
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to user_path(@user)
    assert_not flash.empty?
  end
  
  #レシピ削除失敗パターン
  test "unsuccecsful delete recipe" do
    #未ログイン
    assert_no_difference "Recipe.count" do
      delete recipe_path(@recipe)
    end
    assert_redirected_to root_url
    #違うユーザー
    log_in_as(@other_user)
    assert_no_difference "Recipe.count" do
      delete recipe_path(@recipe)
    end
    assert_redirected_to root_url
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
  
  #材料入力の失敗パターン
  test "unsuccecs pattern of ingredient_input on Recipes/edit" do
    #未ログイン
    assert_no_difference "Ingredient.count" do
      post ingredients_path, params: { ingredients: @input_ingredients,
                                       recipe_id: @recipe.id }
    end
    assert_redirected_to login_url
    assert_not flash.empty?
    #違うユーザー
    log_in_as(@other_user)
    assert_no_difference "Ingredient.count" do
      post ingredients_path, params:{ ingredients: @input_ingredients,
                                     recipe_id: @recipe.id }
    end
    assert_redirected_to root_url
  end
  
  #プロセスの入力成功
  test "success edit procedure" do
    log_in_as(@user)
    #新規入力
    get edit_recipe_path(@recipe)
    assert_difference "Procedure.count", 1 do
      post procedures_path, params:{ procedure: { content:"お湯を沸かします。",
                                                  number: "3"},
                                     recipe_id: @recipe.id }
    end
    #変更
    post procedures_path, params:{ procedure: { content: "スベリヒユを煮ます",
                                                number: "2" },
                                   recipe_id: @recipe.id }
    @procedure_alt.reload
    assert_equal @procedure_alt.content, "スベリヒユを煮ます"
  end
  
  #プロセス入力の失敗パターン
  test "unsuccess pattern of procedure-input on Recipes/edit" do
    #未ログイン
    assert_no_difference "Procedure.count" do
      post procedures_path, params:{ procedure: { content: "お湯を沸かします。",
                                                  number: "3"},
                                     recipe_id: @recipe.id }
    end
    assert_redirected_to login_url
    assert_not flash.empty?
    #違うユーザー
    log_in_as(@other_user)
    assert_no_difference "Procedure.count" do
      post procedures_path, params:{ procedure: { content: "お湯を沸かします。",
                                                  number: "3"},
                                     recipe_id: @recipe.id }
    end
  end
  
  #プロセスの内容の入れ替えテスト
  test "change procedure-function test" do
    log_in_as(@user)
    get edit_recipe_path(@recipe)
    #change_afterメソッドテスト
    post procedures_change_after_path, params:{ recipe_id: @recipe.id,
                                                number: @procedure.number }
    assert_redirected_to edit_recipe_path(@recipe)
    @procedure.reload
    @procedure_alt.reload
    assert_equal @procedure.content, "next process"
    assert_equal @procedure_alt.content, "first process"
    #次の手順が存在しない場合
    post procedures_change_after_path, params:{ recipe_id: @recipe.id,
                                                number: @procedure_alt.number }
    @procedure_alt.reload
    assert_equal @procedure_alt.content, "first process"
    #change_beforeメソッドテスト
    post procedures_change_before_path, params:{ recipe_id: @recipe.id,
                                                 number: @procedure_alt.number }
    assert_redirected_to edit_recipe_path(@recipe)
    @procedure.reload
    @procedure_alt.reload
    assert_equal @procedure.content, "first process"
    assert_equal @procedure_alt.content, "next process"
    #前の手順が存在しない場合
    post procedures_change_before_path, params:{ recipe_id: @recipe.id,
                                                 number: @procedure.number }
    assert_redirected_to edit_recipe_path(@recipe)
    @procedure.reload
    assert_equal @procedure.content, "first process"
  end
  
  #レシピの公開設定テスト
  test "release function test" do
    log_in_as(@user)
    get recipes_path
    #レシピ一覧に表示されていないことを確認
    assert_select "a[href=?]",recipe_path(@recipe), count:0
    #公開設定をオンにして、レシピ一覧に表示されていることを確認
    patch release_recipe_path(@recipe), params: { release: true }
    assert_redirected_to recipe_path(@recipe)
    @recipe.reload
    assert @recipe.release
    get recipes_path
    assert_select "a[href=?]",recipe_path(@recipe), count:1
    #公開設定をオフにして、レシピ一覧に表示されていないことを確認
    patch release_recipe_path(@recipe), params: { release: false }
    assert_redirected_to user_path(@user)
    @recipe.reload
    assert_not @recipe.release
    get recipes_path
    assert_select "a[href=?]",recipe_path(@recipe), count:0
  end
end
