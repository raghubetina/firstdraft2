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

ActiveRecord::Schema[7.0].define(version: 2021_08_25_104645) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "project_hierarchies", id: false, force: :cascade do |t|
    t.uuid "ancestor_id", null: false
    t.uuid "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "project_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "project_desc_idx"
  end

  create_table "project_table_columns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "underscored"
    t.boolean "primary_descriptor", default: false
    t.boolean "unique_identifier", default: false
    t.string "type"
    t.uuid "table_id", null: false
    t.boolean "starter", default: false
    t.boolean "primary_identifier", default: false
    t.boolean "foreign_type", default: false
    t.uuid "foreign_type_for_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["foreign_type_for_id"], name: "index_project_table_columns_on_foreign_type_for_id"
    t.index ["table_id"], name: "index_project_table_columns_on_table_id"
  end

  create_table "project_table_relationships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "origin_id", null: false
    t.uuid "destination_id"
    t.uuid "scope_id"
    t.string "name"
    t.uuid "foreign_key_id"
    t.uuid "key_id"
    t.boolean "polymorphic"
    t.uuid "foreign_key_owner_id"
    t.string "dependent", default: "destroy"
    t.boolean "touch_option"
    t.boolean "optional"
    t.string "cardinality"
    t.boolean "counter_cache"
    t.uuid "source_id"
    t.uuid "through_id"
    t.uuid "inverse_of_id"
    t.integer "relationships_as_source_count", default: 0
    t.integer "relationships_as_through_count", default: 0
    t.string "type"
    t.string "underscored"
    t.string "source_type"
    t.string "as_polymorphic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id"], name: "index_project_table_relationships_on_destination_id"
    t.index ["foreign_key_id"], name: "index_project_table_relationships_on_foreign_key_id"
    t.index ["foreign_key_owner_id"], name: "index_project_table_relationships_on_foreign_key_owner_id"
    t.index ["inverse_of_id"], name: "index_project_table_relationships_on_inverse_of_id"
    t.index ["key_id"], name: "index_project_table_relationships_on_key_id"
    t.index ["origin_id"], name: "index_project_table_relationships_on_origin_id"
    t.index ["scope_id"], name: "index_project_table_relationships_on_scope_id"
    t.index ["source_id"], name: "index_project_table_relationships_on_source_id"
    t.index ["through_id"], name: "index_project_table_relationships_on_through_id"
  end

  create_table "project_table_scopes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "underscored"
    t.uuid "table_id", null: false
    t.integer "relationships_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_project_table_scopes_on_table_id"
  end

  create_table "project_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id", null: false
    t.string "name", null: false
    t.string "underscored"
    t.string "underscored_singular"
    t.string "underscored_plural"
    t.string "classified"
    t.string "humanized"
    t.string "humanized_plural"
    t.integer "columns_count", default: 0
    t.integer "relationships_as_origin_count", default: 0
    t.integer "relationships_as_destination_count", default: 0
    t.integer "scopes_count", default: 0
    t.integer "belongs_tos_count", default: 0
    t.integer "direct_has_ones_count", default: 0
    t.integer "direct_has_manies_count", default: 0
    t.integer "indirect_has_ones_count", default: 0
    t.integer "indirect_has_manies_count", default: 0
    t.boolean "user_account", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_tables_on_project_id"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.citext "codename", null: false
    t.uuid "parent_id"
    t.boolean "public", default: false
    t.integer "fork_order"
    t.integer "tables_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codename"], name: "index_projects_on_codename", unique: true
    t.index ["parent_id"], name: "index_projects_on_parent_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.citext "username", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "projects_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "project_table_columns", "project_table_columns", column: "foreign_type_for_id"
  add_foreign_key "project_table_columns", "project_tables", column: "table_id"
  add_foreign_key "project_table_relationships", "project_table_columns", column: "foreign_key_id"
  add_foreign_key "project_table_relationships", "project_table_columns", column: "key_id"
  add_foreign_key "project_table_relationships", "project_table_relationships", column: "inverse_of_id"
  add_foreign_key "project_table_relationships", "project_table_relationships", column: "source_id"
  add_foreign_key "project_table_relationships", "project_table_relationships", column: "through_id"
  add_foreign_key "project_table_relationships", "project_table_scopes", column: "scope_id"
  add_foreign_key "project_table_relationships", "project_tables", column: "destination_id"
  add_foreign_key "project_table_relationships", "project_tables", column: "foreign_key_owner_id"
  add_foreign_key "project_table_relationships", "project_tables", column: "origin_id"
  add_foreign_key "project_table_scopes", "project_tables", column: "table_id"
  add_foreign_key "project_tables", "projects"
  add_foreign_key "projects", "projects", column: "parent_id"
  add_foreign_key "projects", "users"
end
