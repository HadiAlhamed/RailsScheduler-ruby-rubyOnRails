class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_later
    end
    redirect_to sign_in_path, notice: "If an account with that email exists, you will receive password reset instructions shortly."
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: "Invalid or expired password reset link."
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")
    if @user.update(password_reset_params)
      redirect_to sign_in_path, notice: "Your password has been reset successfully. Please sign in with your new password."
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: "Invalid or expired password reset link."
  end

  private
  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
