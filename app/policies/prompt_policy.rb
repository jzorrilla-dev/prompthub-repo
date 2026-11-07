class PromptPolicy < ApplicationPolicy
  def show?
    record.public_prompt? || owner?
  end

  def fork?
    user.present? && show?
  end

  def manage?
    owner?
  end
end
