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

ActiveRecord::Schema.define(version: 2019_07_19_104252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.string "course_adviser"
    t.string "course_duration"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_courses_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "dept_name"
    t.string "dept_head"
    t.string "dept_email"
    t.bigint "faculty_id"
    t.index ["faculty_id"], name: "index_departments_on_faculty_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "faculty_name"
    t.string "faculty_dean"
    t.string "faculty_email"
  end

  add_foreign_key "courses", "departments"
  add_foreign_key "departments", "faculties"
end
