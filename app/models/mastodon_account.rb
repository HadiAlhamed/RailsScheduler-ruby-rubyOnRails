class MastodonAccount < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :username, uniqueness: true

  def username_with_at
    "@#{username}"
  end

  def client
    require "mastodon"
    Mastodon::REST::Client.new(
      base_url: "https://mastodon.social",
      bearer_token: token
    )
  end
end
