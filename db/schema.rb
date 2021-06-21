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

ActiveRecord::Schema.define(version: 2021_06_21_100253) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

# Could not dump table "feature_masters" because of following StandardError
#   Unknown type 'bool' for column 'master'

  create_table "good_masters", force: :cascade do |t|
    t.text "content"
    t.string "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order", "created_at"], name: "index_good_masters_on_order_and_created_at"
  end

  create_table "job_masters", force: :cascade do |t|
    t.text "content"
    t.string "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order", "created_at"], name: "index_job_masters_on_order_and_created_at"
  end

  create_table "mujin_items", force: :cascade do |t|
    t.string "name"
    t.float "stock"
    t.float "price"
    t.integer "mujin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"user_id\", \"created_at\"", name: "index_mujin_items_on_user_id_and_created_at"
    t.index ["mujin_id"], name: "index_mujin_items_on_mujin_id"
  end

  create_table "mujins", force: :cascade do |t|
    t.string "name"
    t.float "lat"
    t.float "lon"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "content"
    t.text "image64"
    t.index ["user_id"], name: "index_mujins_on_user_id"
  end

  create_table "role_masters", force: :cascade do |t|
    t.text "content"
    t.string "abrev"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content", "created_at"], name: "index_role_masters_on_content_and_created_at"
  end

# Could not dump table "role_transactions" because of following StandardError
#   Unknown type '' for column 'active'

  create_table "role_users", force: :cascade do |t|
    t.integer "role_master_id", null: false
    t.integer "user_id", null: false
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_master_id", "user_id"], name: "index_role_users_on_role_master_id_and_user_id"
    t.index ["role_master_id"], name: "index_role_users_on_role_master_id"
    t.index ["user_id"], name: "index_role_users_on_user_id"
  end

  create_table "sub_feature_masters", force: :cascade do |t|
    t.text "content"
    t.string "abrev"
    t.integer "feature_master_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feature_master_id", "abrev"], name: "index_sub_feature_masters_on_feature_master_id_and_abrev"
    t.index ["feature_master_id"], name: "index_sub_feature_masters_on_feature_master_id"
  end

  create_table "sub_feature_users", force: :cascade do |t|
    t.boolean "active"
    t.integer "sub_feature_master_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sub_feature_master_id"], name: "index_sub_feature_users_on_sub_feature_master_id"
    t.index ["user_id", "sub_feature_master_id"], name: "index_sub_feature_users_on_user_id_and_sub_feature_master_id"
    t.index ["user_id"], name: "index_sub_feature_users_on_user_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'bool' for column 'admin'

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "mujin_items", "mujins"
  add_foreign_key "mujins", "users"
  add_foreign_key "role_transactions", "feature_masters"
  add_foreign_key "role_transactions", "role_masters"
  add_foreign_key "role_transactions", "users"
  add_foreign_key "role_users", "role_masters"
  add_foreign_key "role_users", "users"
  add_foreign_key "sub_feature_masters", "feature_masters"
  add_foreign_key "sub_feature_users", "sub_feature_masters"
  add_foreign_key "sub_feature_users", "users"
end
