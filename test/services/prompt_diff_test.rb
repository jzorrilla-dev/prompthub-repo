require "test_helper"

class PromptDiffTest < ActiveSupport::TestCase
  test "returns unchanged, removed and added lines" do
    rows = PromptDiff.new("rol\nantes\n", "rol\ndespués\n").rows

    assert_equal %i[same removed added], rows.map { |row| row[:type] }
    assert_equal "antes\n", rows[1][:text]
    assert_equal "después\n", rows[2][:text]
  end
end
