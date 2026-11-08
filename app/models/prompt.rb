class Prompt < ApplicationRecord
  enum :visibility, { public_prompt: 0, private_prompt: 1 }, default: :public_prompt

  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :forked_from, class_name: "Prompt", optional: true
  has_many :forks, class_name: "Prompt", foreign_key: :forked_from_id, dependent: :nullify
  has_many :prompt_versions, -> { order(number: :desc) }, dependent: :destroy
  has_many :prompt_results, dependent: :destroy
  has_many :prompt_taggings, dependent: :destroy
  has_many :tags, through: :prompt_taggings
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :prompt_results, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true, length: { maximum: 140 }
  validates :description, length: { maximum: 500 }
  validates :content, presence: true
  validates :ai_model, length: { maximum: 120 }
  validate :forked_from_cannot_be_self

  scope :published, -> { public_prompt }
  scope :recent, -> { order(updated_at: :desc) }
  scope :popular, -> { left_joins(:favorites).group("prompts.id").order(Arel.sql("COUNT(favorites.id) DESC, prompts.updated_at DESC")) }
  scope :favorited_by, ->(user) { joins(:favorites).where(favorites: { user_id: user.id }) }
  scope :search, lambda { |query|
    return all if query.blank?

    terms = query.to_s.scan(/[[:alnum:]]+/)
    return all if terms.empty?

    boolean_query = terms.map { |term| "+#{term}*" }.join(" ")
    escaped = sanitize_sql_like(query.strip)
    left_joins(:tags, :category)
      .where("(MATCH(prompts.title, prompts.description, prompts.content) AGAINST (:boolean_query IN BOOLEAN MODE) OR tags.name LIKE :q OR categories.name LIKE :q)", boolean_query: boolean_query, q: "%#{escaped}%")
      .distinct
  }

  def tag_list
    tags.order(:name).pluck(:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.to_s.split(",").filter_map do |name|
      normalized = name.strip.downcase
      Tag.find_or_create_by(name: normalized) if normalized.present?
    end.uniq
  end

  def snapshot!(actor: user)
    prompt_versions.create!(
      user: actor,
      number: prompt_versions.maximum(:number).to_i + 1,
      title: title,
      description: description,
      content: content,
      ai_model: ai_model,
      change_note: change_note.presence
    )
  end

  def current_version
    prompt_versions.first
  end

  def restore_from!(version, actor: user)
    raise ArgumentError, "La versión no pertenece a este prompt" unless version.prompt_id == id

    transaction do
      update!(
        title: version.title,
        description: version.description,
        content: version.content,
        ai_model: version.ai_model
      )
      self.change_note = "Restaurado desde v#{version.number}"
      snapshot!(actor: actor)
    end
  end

  attr_accessor :change_note

  private

  def forked_from_cannot_be_self
    errors.add(:forked_from, "no puede apuntar al mismo prompt") if forked_from_id.present? && forked_from_id == id
  end
end
