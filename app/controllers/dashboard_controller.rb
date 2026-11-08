class DashboardController < ApplicationController
  before_action :require_authentication

  def show
    @my_prompts = current_user.prompts.includes(:category, :tags).recent.limit(6)
    @favorite_prompts = Prompt.favorited_by(current_user).includes(:user, :category, :tags).published.recent.limit(6)
    @recent_comments = current_user.comments.includes(:prompt).order(created_at: :desc).limit(5)
    @stats = {
      prompts: current_user.prompts.count,
      public_prompts: current_user.prompts.published.count,
      favorites: current_user.favorites.count,
      comments: current_user.comments.count
    }
    @activity = build_activity
  end

  private

  def build_activity
    entries = []
    current_user.prompts.order(updated_at: :desc).limit(8).each do |prompt|
      entries << { occurred_at: prompt.updated_at, kind: "prompt", subject: prompt }
    end
    current_user.comments.includes(:prompt).order(created_at: :desc).limit(8).each do |comment|
      entries << { occurred_at: comment.created_at, kind: "comment", subject: comment }
    end
    current_user.favorites.includes(:prompt).order(created_at: :desc).limit(8).each do |favorite|
      entries << { occurred_at: favorite.created_at, kind: "favorite", subject: favorite }
    end
    entries.sort_by { |entry| entry[:occurred_at] }.reverse.first(8)
  end
end
