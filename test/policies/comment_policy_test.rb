require "test_helper"

class CommentPolicyTest < ActiveSupport::TestCase
  test "author can update and delete their comment" do
    comment = comments(:ada_comment)
    policy = CommentPolicy.new(users(:ada), comment)

    assert policy.update?
    assert policy.destroy?
  end

  test "prompt owner can moderate another user's comment" do
    comment = comments(:grace_comment)
    policy = CommentPolicy.new(users(:ada), comment)

    refute policy.update?
    assert policy.destroy?
  end
end
