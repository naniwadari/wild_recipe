require 'test_helper'

class ProceduresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get procedures_create_url
    assert_response :success
  end

  test "should get update" do
    get procedures_update_url
    assert_response :success
  end

  test "should get destroy" do
    get procedures_destroy_url
    assert_response :success
  end

end
