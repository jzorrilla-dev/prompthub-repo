class AddFulltextIndexToPrompts < ActiveRecord::Migration[8.1]
  def change
    add_index :prompts, %i[title description content], type: :fulltext, name: "index_prompts_on_searchable_content"
  end
end
