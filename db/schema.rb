# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20200829201333) do

  create_table "bills", :force => true do |t|
    t.string   "prefix"
    t.string   "nr"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "salutation"
    t.string   "bill_firstname"
    t.string   "bill_lastname"
    t.string   "bill_street"
    t.string   "bill_zipcity"
    t.string   "text1"
    t.string   "amount1"
    t.string   "text2"
    t.string   "amount2"
    t.string   "text3"
    t.string   "amount3"
    t.string   "text4"
    t.string   "amount4"
    t.string   "total"
    t.date     "issue_date"
    t.date     "paied_date"
    t.string   "paied_amount"
    t.text     "freetext"
    t.text     "comment"
    t.string   "bill_type"
    t.integer  "person_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "company"
    t.string   "bill_streetprefix"
  end

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.text     "course_desc"
    t.date     "course_start"
    t.date     "course_end"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "course_amount"
  end

  create_table "courses_people", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "person_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "doctype"
    t.string   "filename"
    t.string   "comment"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "documents", ["person_id"], :name => "index_documents_on_person_id"

  create_table "grades", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sort_order"
    t.integer  "next_grade"
  end

  create_table "gradings", :force => true do |t|
    t.date     "grading_date"
    t.text     "positive"
    t.text     "negative"
    t.text     "comment"
    t.integer  "person_id"
    t.integer  "grade_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "trainings"
  end

  create_table "notes", :force => true do |t|
    t.text     "note_text"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notes", ["person_id"], :name => "index_notes_on_person_id"

  create_table "people", :force => true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "street"
    t.string   "zipcity"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.date     "birthday"
    t.string   "image"
    t.string   "salutation"
    t.string   "bill_firstname"
    t.string   "bill_lastname"
    t.string   "bill_street"
    t.string   "bill_zipcity"
    t.string   "bill_email"
    t.date     "entry_date"
    t.date     "leave_date"
    t.float    "amount"
    t.float    "discount"
    t.boolean  "is_yearly"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "bill_streetprefix"
    t.string   "gender"
  end

end
