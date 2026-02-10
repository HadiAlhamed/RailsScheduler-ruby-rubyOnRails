class SessionsController < ApplicationController
  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path, notice: "Logged out successfully."
  end

  def new
  end

  def create
    @user = User.find_by(email: sessions_params[:email])
    if @user&.authenticate(sessions_params[:password])
      session[:user_id] = @user.id
      redirect_to root_path , notice: "Logged in successfully."
    else
      flash[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
    
  end

  private
  def sessions_params
    params.require(:sessions).permit(:email, :password)
  end

end
