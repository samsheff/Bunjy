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

ActiveRecord::Schema.define(version: 20140613192231) do

  create_table "identities", force: true do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "payment_methods", force: true do |t|
    t.string   "method_type"
    t.string   "name"
    t.string   "email"
    t.string   "stripe_token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
    t.string   "stripe_recipient_id"
    t.integer  "direction"
  end

  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id"

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.string   "description"
    t.decimal  "fee"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "settings", force: true do |t|
    t.string   "setting_name"
    t.string   "setting_value"
    t.string   "data_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.decimal  "balance",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
    t.string   "password"
  end

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

  create_table "withdrawals", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "withdrawals", ["user_id"], name: "index_withdrawals_on_user_id"

end
