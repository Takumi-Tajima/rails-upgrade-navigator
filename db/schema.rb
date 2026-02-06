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

ActiveRecord::Schema[8.1].define(version: 2026_02_06_020015) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "gem_reports", force: :cascade do |t|
    t.string "changelog_url", null: false
    t.datetime "created_at", null: false
    t.string "current_version", null: false
    t.string "homepage_url", null: false
    t.string "latest_version", null: false
    t.string "name", null: false
    t.bigint "repository_id", null: false
    t.string "source_code_url", null: false
    t.datetime "updated_at", null: false
    t.integer "version_diff_type", default: 0, null: false
    t.index ["repository_id"], name: "index_gem_reports_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.text "ai_analysis", null: false
    t.datetime "analyzed_at"
    t.datetime "created_at", null: false
    t.string "current_rails_version"
    t.string "name", null: false
    t.string "target_rails_version"
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["url"], name: "index_repositories_on_url"
  end

  add_foreign_key "gem_reports", "repositories"
end
