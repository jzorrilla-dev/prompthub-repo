class User < ApplicationRecord
  has_secure_password

  has_many :prompts, dependent: :destroy
  has_many :prompt_versions, dependent: :nullify

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name, presence: true, length: { maximum: 80 }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false },
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
end
