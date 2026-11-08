require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "dashboard requires authentication" do
    get dashboard_url

    assert_redirected_to new_session_path
  end

  test "authenticated user can see dashboard" do
    post session_url, params: { email_address: "ada@example.com", password: "password123" }
    get dashboard_url

    assert_response :success
    assert_select "h1", /Hola, Ada/
    assert_select "h2", /Mis prompts/
  end
end
