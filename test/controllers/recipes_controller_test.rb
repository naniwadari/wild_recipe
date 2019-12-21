require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_recipe_path
    assert_response :success
  end

end
