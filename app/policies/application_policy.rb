class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private

  def owner?
    user.present? && record.respond_to?(:user) && record.user == user
  end
end
