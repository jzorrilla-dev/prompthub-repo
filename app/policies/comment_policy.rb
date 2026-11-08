class CommentPolicy < ApplicationPolicy
  def update?
    owner?
  end

  def destroy?
    owner? || (user.present? && record.prompt.user == user)
  end
end
