class CommentsController < ApplicationController
  before_action :require_authentication
  before_action :set_prompt
  before_action :authorize_prompt_comment!, only: :create
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_comment!, only: %i[edit update destroy]

  def create
    @comment = @prompt.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @prompt, notice: "Comentario publicado." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("comments", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.replace("comment_form", partial: "comments/form", locals: { prompt: @prompt, comment: @prompt.comments.new })
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @prompt, alert: @comment.errors.full_messages.to_sentence }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "comment_form",
            partial: "comments/form",
            locals: { prompt: @prompt, comment: @comment }
          ), status: :unprocessable_entity
        end
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @prompt, notice: "Comentario actualizado." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@comment), partial: "comments/comment", locals: { comment: @comment }) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to @prompt, notice: "Comentario eliminado." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@comment)) }
    end
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def set_comment
    @comment = @prompt.comments.find(params[:id])
  end

  def authorize_prompt_comment!
    return if PromptPolicy.new(current_user, @prompt).comment?

    redirect_to @prompt, alert: "Debes tener acceso al prompt para comentar."
  end

  def authorize_comment!
    return if CommentPolicy.new(current_user, @comment).public_send("#{action_name}?")

    redirect_to @prompt, alert: "No tienes permiso para modificar este comentario."
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
