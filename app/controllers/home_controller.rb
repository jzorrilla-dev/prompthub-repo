class HomeController < ApplicationController
  def index
    @featured_prompts = Prompt.published.includes(:user, :category, :tags).recent.limit(6)
    @prompt_count = Prompt.published.count
    @creator_count = User.joins(:prompts).merge(Prompt.published).distinct.count
  end
end
