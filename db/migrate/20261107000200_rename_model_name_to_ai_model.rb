class RenameModelNameToAiModel < ActiveRecord::Migration[8.1]
  def change
    rename_column :prompts, :model_name, :ai_model
    rename_column :prompt_versions, :model_name, :ai_model
  end
end
