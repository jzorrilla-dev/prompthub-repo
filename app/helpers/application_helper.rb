module ApplicationHelper
  def page_title(title = nil)
    [title, "PromptHub"].compact.join(" · ")
  end

  def visibility_label(prompt)
    prompt.public_prompt? ? "Público" : "Privado"
  end

  def initials(name)
    name.to_s.split.first(2).map { |part| part.first.upcase }.join
  end

  def pagination_path(page)
    url_for(request.query_parameters.merge(page: page))
  end

  def prompt_explore_params(overrides = {})
    {
      q: params[:q],
      mine: params[:mine],
      category_id: params[:category_id],
      model: params[:model],
      tag: params[:tag],
      sort: params[:sort]
    }.merge(overrides).compact
  end
end
