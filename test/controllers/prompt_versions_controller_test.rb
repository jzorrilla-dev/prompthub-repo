require "test_helper"

class PromptVersionsControllerTest < ActionDispatch::IntegrationTest
  test "owner can compare two prompt versions" do
    prompt = prompts(:public_prompt)
    first = prompt.snapshot!
    prompt.update!(content: "Contenido revisado")
    second = prompt.snapshot!

    get compare_prompt_versions_url(prompt, from: first.id, to: second.id)

    assert_response :success
    assert_select "h1", /Comparar versiones/
  end

  test "owner can restore an older version" do
    prompt = prompts(:public_prompt)
    first = prompt.snapshot!
    prompt.update!(content: "Contenido revisado")
    prompt.snapshot!
    post session_url, params: { email_address: "ada@example.com", password: "password123" }

    post restore_prompt_version_url(prompt, first)

    assert_redirected_to prompt_url(prompt)
    assert_equal first.content, prompt.reload.content
  end
end
