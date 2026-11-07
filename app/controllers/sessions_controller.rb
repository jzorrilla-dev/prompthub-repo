class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])

    if user
      destination = redirect_after_authentication
      reset_session
      session[:user_id] = user.id
      redirect_to destination, notice: "Qué bueno verte de nuevo."
    else
      flash.now[:alert] = "El correo o la contraseña no son correctos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Tu sesión se cerró correctamente."
  end
end
