class CreatePromptHub < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :users, :email_address, unique: true

    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true

    create_table :prompts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.references :forked_from, null: true, foreign_key: { to_table: :prompts }
      t.string :title, null: false
      t.text :description
      t.text :content, null: false
      t.string :model_name
      t.integer :visibility, null: false, default: 0
      t.timestamps
    end
    add_index :prompts, :visibility
    add_index :prompts, :updated_at

    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true

    create_table :prompt_taggings do |t|
      t.references :prompt, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :prompt_taggings, %i[prompt_id tag_id], unique: true

    create_table :prompt_results do |t|
      t.references :prompt, null: false, foreign_key: true
      t.string :label
      t.text :content, null: false
      t.timestamps
    end

    create_table :prompt_versions do |t|
      t.references :prompt, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :number, null: false
      t.string :title, null: false
      t.text :description
      t.text :content, null: false
      t.string :model_name
      t.string :change_note
      t.timestamps
    end
    add_index :prompt_versions, %i[prompt_id number], unique: true
  end
end
