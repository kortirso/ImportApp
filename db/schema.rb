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

ActiveRecord::Schema.define(version: 20160722091351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.integer  "category_id",  null: false
    t.integer  "operation_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "links", ["operation_id", "category_id"], name: "index_links_on_operation_id_and_category_id", using: :btree

  create_table "operations", force: :cascade do |t|
    t.string   "invoice_num",                             null: false
    t.date     "invoice_date",                            null: false
    t.date     "operation_date",                          null: false
    t.decimal  "amount",         precision: 10, scale: 2, null: false
    t.string   "reporter"
    t.text     "notes"
    t.string   "status",                                  null: false
    t.string   "kind",                                    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "company_id"
    t.integer  "task_id"
  end

  add_index "operations", ["company_id"], name: "index_operations_on_company_id", using: :btree
  add_index "operations", ["task_id"], name: "index_operations_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "file"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "success",    default: 0
    t.integer  "failure",    default: 0
    t.boolean  "parsed?",    default: false
  end

  add_foreign_key "links", "categories"
  add_foreign_key "links", "operations"
end
