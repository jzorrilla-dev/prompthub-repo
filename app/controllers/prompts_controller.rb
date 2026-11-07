class PromptsController < ApplicationController
  before_action :require_authentication, except: %i[index show]
  before_action :set_prompt, only: %i[show edit update destroy fork]
  before_action :authorize_owner!, only: %i[edit update destroy]
  before_action :authorize_view!, only: :show
  before_action :authorize_fork!, only: :fork

  def index
    scope = Prompt.includes(:user, :category, :tags).search(params[:q])
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = if params[:mine].present? && authenticated?
      scope.where(user: current_user).recent
    else
      scope.published.recent
    end
    @page = [params[:page].to_i, 1].max
    @per_page = 9
    @total_prompts = scope.count
    @total_pages = (@total_prompts.to_f / @per_page).ceil
    @prompts = scope.paginate(page: @page, per_page: @per_page)
    @categories = Category.order(:name)
  end

  def show
    @versions = @prompt.prompt_versions.limit(10)
  end

  def new
    @prompt = current_user.prompts.new
    @prompt.prompt_results.build
    load_categories
  end

  def create
    @prompt = current_user.prompts.new(prompt_params)

    if @prompt.save
      @prompt.snapshot!(actor: current_user)
      redirect_to @prompt, notice: "Prompt publicado correctamente."
    else
      load_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @prompt.prompt_results.build if @prompt.prompt_results.empty?
    load_categories
  end

  def update
    if @prompt.update(prompt_params)
      @prompt.snapshot!(actor: current_user)
      redirect_to @prompt, notice: "Prompt actualizado y nueva versión guardada."
    else
      load_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prompt.destroy!
    redirect_to prompts_path, notice: "Prompt eliminado."
  end

  def fork
    copy = current_user.prompts.new(
      title: "Fork de #{@prompt.title}",
      description: @prompt.description,
      content: @prompt.content,
      ai_model: @prompt.ai_model,
      category: @prompt.category,
      tags: @prompt.tags,
      forked_from: @prompt,
      visibility: :private_prompt
    )

    if copy.save
      copy.snapshot!(actor: current_user)
      redirect_to edit_prompt_path(copy), notice: "Creamos un fork privado para que puedas adaptarlo."
    else
      redirect_to @prompt, alert: "No pudimos crear el fork."
    end
  end

  private

  def set_prompt
    @prompt = Prompt.includes(:user, :category, :tags, :prompt_results).find(params[:id])
  end

  def authorize_owner!
    return if policy_for(@prompt).manage?

    redirect_to @prompt, alert: "No tienes permiso para modificar este prompt."
  end

  def authorize_view!
    return if policy_for(@prompt).show?

    redirect_to prompts_path, alert: "Ese prompt es privado."
  end

  def authorize_fork!
    return if policy_for(@prompt).fork?

    redirect_to @prompt, alert: "No puedes crear un fork de este prompt."
  end

  def load_categories
    @categories = Category.order(:name)
  end

  def prompt_params
    params.require(:prompt).permit(
      :title, :description, :content, :ai_model, :visibility, :category_id, :tag_list, :change_note,
      prompt_results_attributes: %i[id label content _destroy]
    )
  end
end
