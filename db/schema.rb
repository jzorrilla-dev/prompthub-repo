# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_07_000200) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "prompt_results", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "prompt_id", null: false
    t.string "label"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id"], name: "index_prompt_results_on_prompt_id"
  end

  create_table "prompt_taggings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "prompt_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id", "tag_id"], name: "index_prompt_taggings_on_prompt_id_and_tag_id", unique: true
    t.index ["prompt_id"], name: "index_prompt_taggings_on_prompt_id"
    t.index ["tag_id"], name: "index_prompt_taggings_on_tag_id"
  end

  create_table "prompt_versions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "prompt_id", null: false
    t.bigint "user_id"
    t.integer "number", null: false
    t.string "title", null: false
    t.text "description"
    t.text "content", null: false
    t.string "ai_model"
    t.string "change_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id", "number"], name: "index_prompt_versions_on_prompt_id_and_number", unique: true
    t.index ["prompt_id"], name: "index_prompt_versions_on_prompt_id"
    t.index ["user_id"], name: "index_prompt_versions_on_user_id"
  end

  create_table "prompts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id"
    t.bigint "forked_from_id"
    t.string "title", null: false
    t.text "description"
    t.text "content", null: false
    t.string "ai_model"
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_prompts_on_category_id"
    t.index ["forked_from_id"], name: "index_prompts_on_forked_from_id"
    t.index ["updated_at"], name: "index_prompts_on_updated_at"
    t.index ["user_id"], name: "index_prompts_on_user_id"
    t.index ["visibility"], name: "index_prompts_on_visibility"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "prompt_results", "prompts"
  add_foreign_key "prompt_taggings", "prompts"
  add_foreign_key "prompt_taggings", "tags"
  add_foreign_key "prompt_versions", "prompts"
  add_foreign_key "prompt_versions", "users"
  add_foreign_key "prompts", "categories"
  add_foreign_key "prompts", "prompts", column: "forked_from_id"
  add_foreign_key "prompts", "users"
end
