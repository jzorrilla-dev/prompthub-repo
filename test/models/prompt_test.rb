require "test_helper"

class PromptTest < ActiveSupport::TestCase
  test "search finds prompts by title" do
    assert_includes Prompt.search("Revisor"), prompts(:public_prompt)
  end

  test "search filters by model and tag" do
    assert_includes Prompt.where(ai_model: "GPT-5"), prompts(:public_prompt)
    assert_includes Prompt.joins(:tags).where(tags: { name: "code" }), prompts(:public_prompt)
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

  test "restoring a version creates a new current version" do
    prompt = prompts(:public_prompt)
    first = prompt.snapshot!
    prompt.update!(content: "Contenido posterior")
    prompt.snapshot!

    prompt.restore_from!(first, actor: prompt.user)

    assert_equal "Revisa este código y presenta los problemas por prioridad.", prompt.reload.content
    assert_equal 3, prompt.current_version.number
    assert_equal "Restaurado desde v1", prompt.current_version.change_note
  end
end
