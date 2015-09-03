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

ActiveRecord::Schema.define(version: 20150803111202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "circles", force: :cascade do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "circles_users", id: false, force: :cascade do |t|
    t.integer "circle_id"
    t.integer "user_id"
  end

  add_index "circles_users", ["circle_id"], name: "index_circles_users_on_circle_id", using: :btree
  add_index "circles_users", ["user_id"], name: "index_circles_users_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["circle_id"], name: "index_comments_on_circle_id", using: :btree

  create_table "data_objs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "data_type_id"
    t.float    "value"
    t.datetime "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "data_objs", ["user_id"], name: "index_data_objs_on_user_id", using: :btree

  create_table "data_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "maps", ["user_id"], name: "index_maps_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "inviting_id"
    t.integer  "invited_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "service_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "uid"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "tracker_data_types", force: :cascade do |t|
    t.integer  "tracker_type_id"
    t.integer  "data_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tracker_data_types", ["data_type_id"], name: "index_tracker_data_types_on_data_type_id", using: :btree
  add_index "tracker_data_types", ["tracker_type_id"], name: "index_tracker_data_types_on_tracker_type_id", using: :btree

  create_table "tracker_types", force: :cascade do |t|
    t.integer  "service_type_id"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "trackers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.integer  "tracker_type_id"
    t.string   "mac_address"
    t.datetime "lastSyncTime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "trackers", ["user_id"], name: "index_trackers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           default: "",    null: false
    t.string   "encrypted_password",                              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "date_of_birth"
    t.boolean  "is_female",                                       default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.decimal  "lat",                    precision: 10, scale: 6
    t.decimal  "lng",                    precision: 10, scale: 6
    t.string   "city"
    t.string   "country"
    t.datetime "last_sync"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
