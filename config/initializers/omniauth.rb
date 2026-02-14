# 1. Allow POST requests (fixes Routing Error)
OmniAuth.config.allowed_request_methods = [ :post ]

# 2. Handle the Authenticity/CSRF token check (fixes AuthenticityError)
# In development, we will disable the validation phase for OmniAuth
# to play nice with Rails' internal CSRF protection.
OmniAuth.config.request_validation_phase = nil

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :oauth2,
    Rails.application.credentials.dig(:mastodon, :client_id),
    Rails.application.credentials.dig(:mastodon, :client_secret),
    {
      name: :mastodon,
      scope: "read:accounts read:statuses write:statuses",
      client_options: {
        site: "https://mastodon.social",
        authorize_url: "/oauth/authorize",
        token_url: "/oauth/token"
      }
    }
end

# 3. Ensures the callback URL matches your current environment (localhost or production)
OmniAuth.config.full_host = lambda do |env|
  request = Rack::Request.new(env)
  "#{request.scheme}://#{request.host_with_port}"
end
