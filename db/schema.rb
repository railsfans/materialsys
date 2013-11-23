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

ActiveRecord::Schema.define(:version => 20131119042724) do

  create_table "codes", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "parent_id"
    t.string   "footprint"
    t.string   "partnum"
    t.string   "flocation"
    t.string   "partparams"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "manufacturer"
  end

  create_table "outportrecords", :force => true do |t|
    t.string   "code"
    t.string   "partnum"
    t.integer  "quantity"
    t.string   "name"
    t.string   "date"
    t.string   "comment"
    t.string   "footprint"
    t.integer  "record_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "records", :force => true do |t|
    t.string   "people"
    t.string   "situ"
    t.string   "rlocation"
    t.string   "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stores", :force => true do |t|
    t.string   "code"
    t.integer  "currentquantity"
    t.integer  "originquantity"
    t.text     "comment"
    t.string   "name"
    t.float    "unitprice"
    t.integer  "record_id"
    t.string   "partnum"
    t.string   "footprint"
    t.string   "manufacturer"
    t.string   "partparams"
    t.string   "supplier"
    t.datetime "importtime"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "suppliers", :force => true do |t|
    t.string   "company"
    t.string   "address"
    t.string   "website"
    t.string   "contactor"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.text     "comment"
    t.string   "number"
    t.text     "material"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "username"
    t.string   "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
