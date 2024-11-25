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

ActiveRecord::Schema[7.0].define(version: 2024_11_25_140959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hints", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.text "content", null: false
    t.integer "order_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id", "order_number"], name: "index_hints_on_problem_id_and_order_number"
    t.index ["problem_id"], name: "index_hints_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "difficulty"
    t.bigint "week_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "template_code"
    t.index ["week_id"], name: "index_problems_on_week_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.text "code", null: false
    t.string "time_complexity"
    t.string "space_complexity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_solutions_on_problem_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "problem_id", null: false
    t.text "code"
    t.integer "status"
    t.jsonb "test_results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "test_cases", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.text "input"
    t.text "expected_output"
    t.boolean "is_hidden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_test_cases_on_problem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "number"
    t.string "theme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "hints", "problems"
  add_foreign_key "problems", "weeks"
  add_foreign_key "solutions", "problems"
  add_foreign_key "submissions", "problems"
  add_foreign_key "submissions", "users"
  add_foreign_key "test_cases", "problems"
end
