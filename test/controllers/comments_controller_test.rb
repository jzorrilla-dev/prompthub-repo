require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "anonymous visitors cannot comment" do
    post prompt_comments_url(prompts(:public_prompt)), params: { comment: { body: "Comentario" } }

    assert_redirected_to new_session_path
  end

  test "authenticated users can create a comment" do
    post session_url, params: { email_address: "ada@example.com", password: "password123" }

    assert_difference("Comment.count", 1) do
      post prompt_comments_url(prompts(:public_prompt)), params: { comment: { body: "Una observación útil." } }
    end
    assert_redirected_to prompt_url(prompts(:public_prompt))
  end
end
