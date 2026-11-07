class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user, optional: true

  validates :number, presence: true, uniqueness: { scope: :prompt_id }
  validates :title, :content, presence: true
  validates :change_note, length: { maximum: 255 }
end
