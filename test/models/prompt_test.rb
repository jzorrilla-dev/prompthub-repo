require "test_helper"

class PromptTest < ActiveSupport::TestCase
  test "search finds prompts by title" do
    assert_includes Prompt.search("Revisor"), prompts(:public_prompt)
  end

  test "snapshot records sequential versions" do
    prompt = prompts(:public_prompt)
    first = prompt.snapshot!
    prompt.update!(content: "Contenido mejorado")
    second = prompt.snapshot!

    assert_equal 1, first.number
    assert_equal 2, second.number
    assert_equal "Contenido mejorado", second.content
  end

  test "pagination limits and offsets a relation" do
    page = Prompt.paginate(page: 2, per_page: 1)

    assert_equal 1, page.limit_value
    assert_equal 1, page.offset_value
  end

  test "a prompt cannot fork itself" do
    prompt = prompts(:public_prompt)
    prompt.forked_from = prompt

    refute prompt.valid?
    assert_includes prompt.errors[:forked_from], "no puede apuntar al mismo prompt"
  end
end
