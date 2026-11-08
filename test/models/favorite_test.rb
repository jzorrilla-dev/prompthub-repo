require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  test "a user cannot favorite the same prompt twice" do
    favorite = favorites(:ada_public_prompt)
    duplicate = Favorite.new(user: favorite.user, prompt: favorite.prompt)

    refute duplicate.valid?
    assert_includes duplicate.errors[:prompt_id], "ya está en uso"
  end
end
