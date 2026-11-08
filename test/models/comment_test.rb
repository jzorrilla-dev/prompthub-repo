require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "comment requires a body" do
    comment = Comment.new(user: users(:ada), prompt: prompts(:public_prompt), body: "")

    refute comment.valid?
    assert_includes comment.errors[:body], "no puede estar vacío"
  end

  test "comment belongs to its author and prompt" do
    comment = comments(:ada_comment)

    assert_equal users(:ada), comment.user
    assert_equal prompts(:public_prompt), comment.prompt
  end
end
