class PromptPolicy < ApplicationPolicy
  def show?
    record.public_prompt? || owner?
  end

  def fork?
    user.present? && show?
  end

  def favorite?
    user.present? && record.public_prompt?
  end

  def comment?
    user.present? && show?
  end

  def manage?
    owner?
  end
end
