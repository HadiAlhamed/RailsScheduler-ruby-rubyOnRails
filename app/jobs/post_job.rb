class PostJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post # exit quietly if post was deleted
    return if post.published? # this handles if we changed the time to earlier date

    # suppose we have changed the time of publish_at,
    # instead of cancelling the job of previous publish_at date
    # we just check if its publish_at is in the future or still the same
    return if post.publish_at > Time.current # this handles if we changed the time to later date

    post.publish_to_mastodon!
  end
end
