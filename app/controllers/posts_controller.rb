class PostsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  def index
    @posts = Current.user.posts
  end
  #
  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.create(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  #
  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  #
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully unscheduled."
  end

  private
  def post_params
    params.require(:post).permit(:mastodon_account_id, :body, :publish_at)
  end
  def set_post
    @post = Current.user.posts.find(params[:id])
  end
end
