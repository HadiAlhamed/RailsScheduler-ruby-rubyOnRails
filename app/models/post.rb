class Post < ApplicationRecord
  belongs_to :user
  belongs_to :mastodon_account
  validates :body, length: { minimum: 1, maximum: 280 }
  validates :publish_at, presence: true

  after_initialize do
    self.publish_at ||= 24.hours.from_now
  end

  after_save_commit do
    if publish_at_previously_changed?
      PostJob.set(wait_until: publish_at).perform_later(self.id)
    end
  end

  def published?
    post_id?
  end
  def publish_to_mastodon!
      published_status = mastodon_account.client.create_status(body)
      update(post_id: published_status.id)
  end

  def unpublish_from_mastodon!
    client.destroy_status(self.post_id) if self.post_id.present?
  end
end
