# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180628025408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artifact_demands", force: :cascade do |t|
    t.bigint "artifact_id", null: false
    t.bigint "demand_id", null: false
    t.bigint "user_id", null: false
    t.integer "version_index", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artifact_id", "demand_id"], name: "index_artifact_demands_on_artifact_id_and_demand_id", unique: true
    t.index ["artifact_id"], name: "index_artifact_demands_on_artifact_id"
    t.index ["demand_id"], name: "index_artifact_demands_on_demand_id"
    t.index ["user_id"], name: "index_artifact_demands_on_user_id"
  end

  create_table "artifact_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "project_id"], name: "index_artifact_statuses_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_artifact_statuses_on_project_id"
  end

  create_table "artifact_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.index ["name", "project_id"], name: "index_artifact_types_on_name_and_project_id"
    t.index ["project_id"], name: "index_artifact_types_on_project_id"
  end

  create_table "artifacts", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "description"
    t.string "priority"
    t.bigint "artifact_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.bigint "attachment_id"
    t.bigint "artifact_status_id", null: false
    t.index ["artifact_status_id"], name: "index_artifacts_on_artifact_status_id"
    t.index ["artifact_type_id"], name: "index_artifacts_on_artifact_type_id"
    t.index ["code", "project_id"], name: "index_artifacts_on_code_and_project_id"
    t.index ["project_id"], name: "index_artifacts_on_project_id"
    t.index ["user_id"], name: "index_artifacts_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "artifact_id", null: false
    t.integer "artifact_version_index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.index ["artifact_id"], name: "index_attachments_on_artifact_id"
  end

  create_table "chart_data", force: :cascade do |t|
    t.bigint "artifact_status_id", null: false
    t.bigint "artifact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artifact_id"], name: "index_chart_data_on_artifact_id"
    t.index ["artifact_status_id"], name: "index_chart_data_on_artifact_status_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "artifact_id", null: false
    t.bigint "user_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artifact_id"], name: "index_comments_on_artifact_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "demands", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "release"
    t.bigint "responsible_user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_demands_on_name", unique: true
    t.index ["project_id"], name: "index_demands_on_project_id"
    t.index ["responsible_user_id"], name: "index_demands_on_responsible_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "projects_users", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "relationship_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.string "color", null: false
    t.index ["color", "project_id"], name: "index_relationship_types_on_color_and_project_id"
    t.index ["name", "project_id"], name: "index_relationship_types_on_name_and_project_id"
    t.index ["project_id"], name: "index_relationship_types_on_project_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "origin_artifact_id", null: false
    t.bigint "end_artifact_id", null: false
    t.bigint "relationship_type_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.index ["end_artifact_id"], name: "index_relationships_on_end_artifact_id"
    t.index ["origin_artifact_id", "end_artifact_id"], name: "index_relationships_on_origin_artifact_id_and_end_artifact_id", unique: true
    t.index ["origin_artifact_id"], name: "index_relationships_on_origin_artifact_id"
    t.index ["project_id"], name: "index_relationships_on_project_id"
    t.index ["relationship_type_id"], name: "index_relationships_on_relationship_type_id"
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "username"
    t.integer "roles_mask"
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "artifact_demands", "artifacts"
  add_foreign_key "artifact_demands", "demands"
  add_foreign_key "artifact_demands", "users"
  add_foreign_key "artifact_statuses", "projects"
  add_foreign_key "artifact_types", "projects"
  add_foreign_key "artifacts", "artifact_statuses"
  add_foreign_key "artifacts", "artifact_types"
  add_foreign_key "artifacts", "projects"
  add_foreign_key "artifacts", "users"
  add_foreign_key "attachments", "artifacts"
  add_foreign_key "chart_data", "artifact_statuses"
  add_foreign_key "chart_data", "artifacts"
  add_foreign_key "comments", "artifacts"
  add_foreign_key "comments", "users"
  add_foreign_key "demands", "projects"
  add_foreign_key "demands", "users", column: "responsible_user_id"
  add_foreign_key "projects", "users"
  add_foreign_key "projects_users", "projects"
  add_foreign_key "projects_users", "users"
  add_foreign_key "relationship_types", "projects"
  add_foreign_key "relationships", "artifacts", column: "end_artifact_id"
  add_foreign_key "relationships", "artifacts", column: "origin_artifact_id"
  add_foreign_key "relationships", "projects"
  add_foreign_key "relationships", "relationship_types"
  add_foreign_key "relationships", "users"
end
