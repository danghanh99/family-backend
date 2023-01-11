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

ActiveRecord::Schema[7.0].define(version: 2023_01_10_025358) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_lists", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_check_lists_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "description"
    t.boolean "daily", default: false
    t.boolean "weekly", default: false
    t.boolean "monthly", default: false
    t.boolean "is_cancelled", default: false
    t.string "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "to_dos", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "check_list_id"
    t.string "todo_text"
    t.boolean "is_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_list_id"], name: "index_to_dos_on_check_list_id"
    t.index ["user_id"], name: "index_to_dos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
