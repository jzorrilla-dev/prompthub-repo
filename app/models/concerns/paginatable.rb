module Paginatable
  extend ActiveSupport::Concern

  class_methods do
    def paginate(page: 1, per_page: 20)
      current_page = [page.to_i, 1].max
      size = [[per_page.to_i, 1].max, 50].min

      limit(size).offset((current_page - 1) * size)
    end
  end
end
