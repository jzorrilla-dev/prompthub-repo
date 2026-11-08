class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :prompt

  scope :recent, -> { order(created_at: :asc) }

  validates :body, presence: true, length: { maximum: 2_000 }
end
