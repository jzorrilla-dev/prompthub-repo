class FavoritesController < ApplicationController
  before_action :require_authentication
  before_action :set_prompt, only: %i[create destroy]
  before_action :authorize_favorite!, only: %i[create destroy]

  def index
    scope = Prompt.includes(:user, :category, :tags).favorited_by(current_user).recent
    @page = [params[:page].to_i, 1].max
    @per_page = 9
    @total_prompts = scope.count
    @total_pages = (@total_prompts.to_f / @per_page).ceil
    @prompts = scope.paginate(page: @page, per_page: @per_page)
  end

  def create
    current_user.favorites.find_or_create_by!(prompt: @prompt)
    respond_to_favorite(true)
  end

  def destroy
    current_user.favorites.find_by(prompt: @prompt)&.destroy!
    respond_to_favorite(false)
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def authorize_favorite!
    return if policy_for(@prompt).favorite?

    redirect_to @prompt, alert: "Solo puedes guardar prompts públicos."
  end

  def respond_to_favorite(favorited)
    respond_to do |format|
      format.html { redirect_to @prompt, notice: favorited ? "Prompt guardado en favoritos." : "Prompt eliminado de favoritos." }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          helpers.dom_id(@prompt, :favorite),
          partial: "prompts/favorite_button",
          locals: { prompt: @prompt, favorited: favorited }
        )
      end
    end
  end
end
