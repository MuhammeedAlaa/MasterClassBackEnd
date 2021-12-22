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

ActiveRecord::Schema.define(version: 2021_12_21_232227) do

  create_table "activities", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "link"
    t.string "name", null: false
    t.string "document"
    t.string "description"
    t.index ["course_id"], name: "index_activities_on_course_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_auth_id"
    t.datetime "birthday"
    t.string "image"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_auth_id", null: false
    t.integer "course_id", null: false
    t.integer "parent_id"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_comments_on_course_id"
    t.index ["user_auth_id"], name: "index_comments_on_user_auth_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_auth_id", null: false
    t.string "image"
    t.string "about"
    t.index ["user_auth_id"], name: "index_courses_on_user_auth_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "user_auth_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_auth_id"], name: "index_enrollments_on_user_auth_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_auth_id"
    t.datetime "birthday"
    t.string "image"
  end

  create_table "learners", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_auth_id"
    t.datetime "birthday"
    t.string "image"
  end

  create_table "user_auths", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role"
    t.string "user_name"
    t.index ["email"], name: "index_user_auths_on_email", unique: true
    t.index ["user_name"], name: "index_user_auths_on_user_name", unique: true
  end

  add_foreign_key "activities", "courses"
  add_foreign_key "comments", "courses"
  add_foreign_key "comments", "user_auths"
  add_foreign_key "courses", "user_auths"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "user_auths"
end
