class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @prompts = @user.prompts.published.includes(:user, :category, :tags).recent.limit(6)
    @stats = {
      prompts: @user.prompts.published.count,
      received_favorites: Favorite.joins(:prompt).where(prompts: { user_id: @user.id }).count,
      comments: @user.comments.count,
      forks: @user.prompts.where.not(forked_from_id: nil).count
    }
  end
end
