class ApplicationController < ActionController::Base
  before_action :set_current_user

  allow_browser versions: :modern
  stale_when_importmap_changes

  # Skip CSRF for OmniAuth callbacks
  skip_before_action :verify_authenticity_token, if: :omniauth_request?

  def set_current_user
    if session[:user_id] # && Current.user.nil?
      Current.user = User.find_by(id: session[:user_id])
    end
  end

  def require_user_logged_in!
    redirect_to sign_in_path, alert: "You must be logged in to access this page, please login then try again" if Current.user.nil?
  end

  private

  def omniauth_request?
    request.path.start_with?("/auth/")
  end
end
