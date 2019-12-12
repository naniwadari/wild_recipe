require 'test_helper'

class ActiveAdminTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:admin_user)
    @non_admin = users(:recipeman)
  end
  
  test "admin user should access management-screen" do
    log_in_as(@admin)
    get admin_root_path
    assert flash.empty?
  end
  
  test "not logged in user should redirect to root_path" do
    get admin_root_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_not flash.empty?
  end
  
  test "not admin user should redirect to root_path" do
    log_in_as(@non_admin)
    get admin_root_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_not flash.empty?
  end
end
