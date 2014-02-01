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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140201155609) do

  create_table "agent_names", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_categories", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_statuses", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parishes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_apps", force: true do |t|
    t.string   "reference",                               null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_status_id"
    t.string   "applicant"
    t.string   "app_property"
    t.decimal  "latitude",        precision: 8, scale: 6
    t.decimal  "longitude",       precision: 8, scale: 6
    t.integer  "app_category_id"
    t.integer  "parish_id"
    t.integer  "agent_name_id"
  end

  add_index "planning_apps", ["agent_name_id"], name: "index_planning_apps_on_agent_name_id", using: :btree
  add_index "planning_apps", ["app_category_id"], name: "index_planning_apps_on_app_category_id", using: :btree
  add_index "planning_apps", ["app_status_id"], name: "index_planning_apps_on_app_status_id", using: :btree
  add_index "planning_apps", ["parish_id"], name: "index_planning_apps_on_parish_id", using: :btree

  add_foreign_key "planning_apps", "agent_names", name: "planning_apps_agent_name_id_fk"
  add_foreign_key "planning_apps", "app_categories", name: "planning_apps_app_category_id_fk"
  add_foreign_key "planning_apps", "app_statuses", name: "planning_apps_app_status_id_fk"
  add_foreign_key "planning_apps", "parishes", name: "planning_apps_parish_id_fk"

end
