class PromptDiff
  MAX_LINES = 800

  def initialize(before, after)
    @before = before.to_s.lines.first(MAX_LINES)
    @after = after.to_s.lines.first(MAX_LINES)
  end

  def rows
    matrix = lcs_matrix
    before_index = 0
    after_index = 0
    result = []

    while before_index < @before.length || after_index < @after.length
      if before_index < @before.length && after_index < @after.length && @before[before_index] == @after[after_index]
        result << { type: :same, text: @before[before_index] }
        before_index += 1
        after_index += 1
      elsif after_index >= @after.length || (before_index < @before.length && matrix[before_index + 1][after_index] >= matrix[before_index][after_index + 1])
        result << { type: :removed, text: @before[before_index] }
        before_index += 1
      else
        result << { type: :added, text: @after[after_index] }
        after_index += 1
      end
    end

    result
  end

  private

  def lcs_matrix
    matrix = Array.new(@before.length + 1) { Array.new(@after.length + 1, 0) }

    (@before.length - 1).downto(0) do |before_index|
      (@after.length - 1).downto(0) do |after_index|
        matrix[before_index][after_index] = if @before[before_index] == @after[after_index]
          matrix[before_index + 1][after_index + 1] + 1
        else
          [matrix[before_index + 1][after_index], matrix[before_index][after_index + 1]].max
        end
      end
    end

    matrix
  end
end
