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

ActiveRecord::Schema.define(version: 20171011212538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artifact_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artifact_types_on_name", unique: true
  end

  create_table "artifacts", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "description"
    t.string "priority"
    t.bigint "artifact_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artifact_type_id"], name: "index_artifacts_on_artifact_type_id"
  end

  create_table "relationship_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_relationship_types_on_name", unique: true
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "origin_artifact_id", null: false
    t.bigint "end_artifact_id", null: false
    t.bigint "relationship_type_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_artifact_id"], name: "index_relationships_on_end_artifact_id"
    t.index ["origin_artifact_id", "end_artifact_id"], name: "index_relationships_on_origin_artifact_id_and_end_artifact_id", unique: true
    t.index ["origin_artifact_id"], name: "index_relationships_on_origin_artifact_id"
    t.index ["relationship_type_id"], name: "index_relationships_on_relationship_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "artifacts", "artifact_types"
  add_foreign_key "relationships", "artifacts", column: "end_artifact_id"
  add_foreign_key "relationships", "artifacts", column: "origin_artifact_id"
  add_foreign_key "relationships", "relationship_types"
end
