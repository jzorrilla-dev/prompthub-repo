require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "public profile shows public prompts" do
    get user_url(users(:ada))

    assert_response :success
    assert_select "h1", "Ada Lovelace"
    assert_select "h2", /Prompts de Ada/
    assert_includes response.body, "Revisor de código"
    refute_includes response.body, "Idea privada"
  end
end
