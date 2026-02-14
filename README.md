# RailsScheduler 

A Ruby on Rails application for scheduling Mastodon posts, developed following the GoRails "Scheduled Tweets" series. This app allows users to authenticate, connect multiple Mastodon accounts via OAuth, and schedule content to be published at a future date and time.

## 🛠 Tech Stack

* **Framework:** Ruby on Rails 8.1.2
* **Database:** PostgreSQL (Transitioned from SQLite)
* **Authentication:** Custom session-based auth using `has_secure_password` and `bcrypt`
* **OAuth:** OmniAuth with OAuth2 Strategy
* **Background Jobs:** Sidekiq & Redis
* **Frontend:** Bootstrap 5 & Hotwire (Turbo/Stimulus)

---

##  Getting Started

### 1. Prerequisites

Ensure you have the following installed:

* **Ruby 3.2+**
* **PostgreSQL**
* **Redis** (Required for Sidekiq)

### 2. Installation

```bash
# Clone the repository
git clone https://github.com/HadiAlhamed/RailsScheduler-ruby-rubyOnRails
cd RailsScheduler

# Install dependencies
bundle install

```

### 3. Database Setup

Ensure PostgreSQL is running, then run:

```bash
rails db:create
rails db:migrate

```

### 4. Configuration (Credentials)

Add your Mastodon API credentials to the Rails encrypted credentials file:

```bash
rails credentials:edit

```

Add the following block:

```yaml
mastodon:
  client_id: YOUR_CLIENT_ID
  client_secret: YOUR_CLIENT_SECRET

```

---

##  Key Implementation Details

### OAuth & Security (OmniAuth 2.0)

Due to security updates in OmniAuth 2.0, the application handles the OAuth flow with the following requirements:

* **POST Requests:** All "Connect" actions must use `button_to` with `method: :post`. Standard `link_to` (GET) will result in a Routing Error.
* **Turbo Integration:** Rails Turbo is disabled for the OAuth handshake using `data: { turbo: false }`.
* **CSRF Handling:** The `omniauth.rb` initializer is configured with `OmniAuth.config.request_validation_phase = nil` for development environments.

### Database Schema

* **Users:** Handles secure authentication.
* **MastodonAccounts:** Stores OAuth tokens, usernames, and profile images url.
* **Posts:** Stores the body of the message and the `publish_at` timestamp.

### Background Processing

Posts are delivered to the Mastodon API via **Sidekiq**. To run the worker in a separate terminal:

```bash
bundle exec sidekiq

```

---

##  Troubleshooting

**Routing Error (`No route matches [GET] "/auth/mastodon"`)**
This occurs because OmniAuth 2.0+ strictly forbids GET requests for starting the OAuth flow. Ensure your view uses a `button_to` with `method: :post`.

**Authenticity Error (`OmniAuth::AuthenticityError`)**
If you encounter this, ensure your `config/initializers/omniauth.rb` has been updated with the proper request validation settings and that you have restarted your Rails server.

---

##  License

This project is open-source and available under the [MIT License](https://www.google.com/search?q=LICENSE).