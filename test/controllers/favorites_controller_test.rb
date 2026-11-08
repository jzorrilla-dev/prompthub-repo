require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "anonymous visitors must authenticate to favorite" do
    post prompt_favorite_url(prompts(:public_prompt))

    assert_redirected_to new_session_path
  end

  test "authenticated users can favorite and unfavorite a public prompt" do
    post session_url, params: { email_address: "grace@example.com", password: "password123" }
    prompt = prompts(:public_prompt)

    assert_difference("Favorite.count", 1) do
      post prompt_favorite_url(prompt)
    end
    assert_redirected_to prompt_url(prompt)

    assert_difference("Favorite.count", -1) do
      delete prompt_favorite_url(prompt)
    end
    assert_redirected_to prompt_url(prompt)
  end
end
