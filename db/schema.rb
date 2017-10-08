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

ActiveRecord::Schema.define(version: 20171008010844) do

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

  add_foreign_key "artifacts", "artifact_types"
  add_foreign_key "relationships", "artifacts", column: "end_artifact_id"
  add_foreign_key "relationships", "artifacts", column: "origin_artifact_id"
  add_foreign_key "relationships", "relationship_types"
end
