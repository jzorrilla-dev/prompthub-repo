class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :prompt

  validates :prompt_id, uniqueness: { scope: :user_id }
end
