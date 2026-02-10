class ApplicationController < ActionController::Base
  before_action :set_current_user # before any action of any controller runs ,
  # this method will run and set the current user in the Current class
  # the first thing that happens when a request comes

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def set_current_user
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id]) # find throws when not found , find_by doesn't throw
    end
  end

  def require_user_logged_in!
    redirect_to sign_in_path, alert: "You must be logged in to change password" if Current.user.nil?
  end
end
