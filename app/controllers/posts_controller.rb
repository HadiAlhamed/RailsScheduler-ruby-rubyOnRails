class PostsController < ApplicationController
  before_action :require_user_logged_in!
  def index
    @posts = Current.user.posts
  end
  #
  def new
    @post = Post.new
  end

  def create
  end
  #
  def show
  end

  def edit
  end

  def update
  end
  #
  def destroy
  end
end
