require "test_helper"

class PromptsControllerTest < ActionDispatch::IntegrationTest
  test "public prompt is visible anonymously" do
    get prompt_url(prompts(:public_prompt))
    assert_response :success
  end

  test "private prompt redirects other users" do
    get prompt_url(prompts(:private_prompt))
    assert_redirected_to prompts_path
  end

  test "new requires authentication" do
    get new_prompt_url
    assert_redirected_to new_session_path
  end
end
