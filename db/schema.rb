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

ActiveRecord::Schema.define(version: 20151129125638) do

  create_table "ageings", force: true do |t|
    t.string   "ageing"
    t.integer  "incident"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "uploaded_at"
  end

  create_table "change_details", force: true do |t|
    t.integer  "created"
    t.integer  "closed"
    t.date     "operating_date"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incident_backlogs", force: true do |t|
    t.integer  "p1"
    t.integer  "p2"
    t.integer  "p3"
    t.integer  "p4"
    t.integer  "total"
    t.date     "operating_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "uploaded_at"
  end

  create_table "incidents", force: true do |t|
    t.string   "customer"
    t.string   "infra"
    t.string   "device_name"
    t.string   "service_no"
    t.string   "domain"
    t.string   "management_id"
    t.text     "public_ip"
    t.string   "ilo_ip"
    t.string   "roles"
    t.string   "server_owners"
    t.string   "connectivity"
    t.string   "location_site"
    t.string   "location_rack"
    t.string   "vendor"
    t.string   "model"
    t.string   "os_ios"
    t.string   "technology"
    t.string   "support_vendor"
    t.string   "ram"
    t.string   "cpu"
    t.string   "cpu_speed"
    t.string   "database"
    t.string   "database_version"
    t.string   "serial_number"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "uploaded_at"
  end

  create_table "inflow_vs_closures", force: true do |t|
    t.integer  "created"
    t.integer  "closed"
    t.date     "operating_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "uploaded_at"
  end

  create_table "other_backlogs", force: true do |t|
    t.integer  "backlogs"
    t.date     "operating_date"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "others", force: true do |t|
    t.integer  "created"
    t.integer  "closed"
    t.date     "operating_date"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_ticket_aegings", force: true do |t|
    t.string   "days"
    t.integer  "number"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_tickets", force: true do |t|
    t.integer  "created"
    t.integer  "closed"
    t.date     "operating_date"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sla_compliances", force: true do |t|
    t.integer  "target_sla"
    t.integer  "adjusted_sla"
    t.integer  "unadjusted_sla"
    t.date     "operating_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "uploaded_at"
  end

  create_table "status_for_open_tickets", force: true do |t|
    t.integer  "assigned"
    t.integer  "awaiting_change"
    t.integer  "monitor"
    t.integer  "pending_customer"
    t.integer  "pending_supplier"
    t.integer  "pending_telstra"
    t.integer  "update_received"
    t.integer  "work_in_progress"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unsuccessful_changes", force: true do |t|
    t.integer  "unsuccessful_changes"
    t.date     "operating_date"
    t.date     "uploaded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
