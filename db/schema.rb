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

ActiveRecord::Schema.define(version: 2021_05_12_040922) do

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
    t.index ["mujin_id"], name: "index_mujin_items_on_mujin_id"
  end

  create_table "mujins", force: :cascade do |t|
    t.string "name"
    t.float "lat"
    t.float "lon"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mujins_on_user_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'bool' for column 'admin'

  add_foreign_key "mujin_items", "mujins"
  add_foreign_key "mujins", "users"
end
