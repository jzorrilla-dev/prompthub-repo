class Tag < ApplicationRecord
  has_many :prompt_taggings, dependent: :destroy
  has_many :prompts, through: :prompt_taggings

  normalizes :name, with: ->(name) { name.strip.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }
end
