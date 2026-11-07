class PromptResult < ApplicationRecord
  belongs_to :prompt

  validates :content, presence: true
  validates :label, length: { maximum: 120 }
end
