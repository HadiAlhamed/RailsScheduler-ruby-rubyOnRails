class MastodonAccountsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_mastodon_account, only: [ :destroy ]
  def index
    @mastodon_accounts = Current.user.mastodon_accounts.all
  end

  def destroy
    @account.destroy
    redirect_to mastodon_accounts_path, notice: "Successfully disconnected @#{@account.username}"
  end

  private
  def set_mastodon_account
        @account = Current.user.mastodon_accounts.find(params[:id])
  end
end
