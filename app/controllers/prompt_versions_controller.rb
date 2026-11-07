class PromptVersionsController < ApplicationController
  def show
    @prompt = Prompt.find(params[:prompt_id])
    unless policy_for(@prompt).show?
      redirect_to prompts_path, alert: "Ese prompt es privado."
      return
    end

    @version = @prompt.prompt_versions.find(params[:id])
  end
end
