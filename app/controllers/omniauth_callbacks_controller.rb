class OmniauthCallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :auth ]

  def mastodon
    token = auth.credentials.token # we need this to allow the user to make api calls to mastodon
    #                               from our app.
    mastodon_domain = "mastodon.social"

    # API call to get full user info
    uri = URI("https://#{mastodon_domain}/api/v1/accounts/verify_credentials")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    user_info = JSON.parse(res.body)
    account = Current.user.mastodon_accounts.find_or_initialize_by(username: user_info["username"])
    account.update!(
      name: user_info["display_name"],
      token: token,
      image: user_info["avatar"]
    )
    redirect_to mastodon_accounts_path, notice: "Successfully connected to your account!"
  rescue => e
    Rails.logger.error e.full_message
    redirect_to root_path, alert: e.message.to_s
    # render json: { error: e.message }, status: 500
  end


  def auth
    request.env["omniauth.auth"]
  end
end
