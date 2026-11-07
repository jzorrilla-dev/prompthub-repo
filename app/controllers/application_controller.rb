class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :resume_session
  helper_method :authenticated?, :current_user

  private

  def resume_session
    Current.user = User.find_by(id: session[:user_id])
  end

  def current_user
    Current.user
  end

  def authenticated?
    current_user.present?
  end

  def require_authentication
    return if authenticated?

    session[:return_to_after_authenticating] = request.fullpath if request.get?
    redirect_to new_session_path, alert: "Inicia sesión para continuar."
  end

  def redirect_after_authentication
    session.delete(:return_to_after_authenticating) || prompts_path
  end

  def policy_for(record)
    "#{record.class.name}Policy".constantize.new(current_user, record)
  end
end
