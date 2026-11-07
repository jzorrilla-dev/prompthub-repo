require "test_helper"

class PromptPolicyTest < ActiveSupport::TestCase
  test "anyone can view a public prompt" do
    assert PromptPolicy.new(nil, prompts(:public_prompt)).show?
  end

  test "anonymous visitors cannot view a private prompt" do
    refute PromptPolicy.new(nil, prompts(:private_prompt)).show?
  end

  test "only the owner can manage a prompt" do
    prompt = prompts(:private_prompt)

    assert PromptPolicy.new(users(:grace), prompt).manage?
    refute PromptPolicy.new(users(:ada), prompt).manage?
  end
end
