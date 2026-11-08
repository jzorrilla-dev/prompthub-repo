class PromptVersionsController < ApplicationController
  before_action :set_prompt
  before_action :require_authentication, only: :restore
  before_action :set_version, only: %i[show restore]
  before_action :authorize_view!, only: %i[show compare]
  before_action :authorize_manage!, only: :restore

  def show
    @current_version = @prompt.current_version
    @previous_version = @prompt.prompt_versions.where("number < ?", @version.number).first
  end

  def compare
    @versions = @prompt.prompt_versions
    @from = @prompt.prompt_versions.find(params[:from])
    @to = @prompt.prompt_versions.find(params[:to])
    @diff_rows = PromptDiff.new(@from.content, @to.content).rows
  rescue ActiveRecord::RecordNotFound
    redirect_to @prompt, alert: "No encontramos esas versiones."
  end

  def restore
    @prompt.restore_from!(@version, actor: current_user)
    redirect_to @prompt, notice: "Restauramos la versión #{@version.number} y creamos una nueva revisión."
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def set_version
    @version = @prompt.prompt_versions.find(params[:id])
  end

  def authorize_view!
    return if policy_for(@prompt).show?

    redirect_to prompts_path, alert: "Ese prompt es privado."
  end

  def authorize_manage!
    return if policy_for(@prompt).manage?

    redirect_to @prompt, alert: "Solo el dueño puede restaurar versiones."
  end
end
