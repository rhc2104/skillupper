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

ActiveRecord::Schema.define(version: 2018_09_13_184305) do

  create_table "user_submissions", force: :cascade do |t|
    t.integer "user_id"
    t.string "content_name"
    t.string "language_name"
    t.text "submitted_code"
    t.boolean "succeeded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "content_name"], name: "index_user_submissions_on_user_id_and_content_name"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "country_code"
    t.boolean "interested_in_jobs"
    t.string "years_of_experience"
    t.string "programming_language"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
