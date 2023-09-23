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

ActiveRecord::Schema.define(version: 2023_09_23_172426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hostnames", force: :cascade do |t|
    t.string "hostname", null: false
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "ip", null: false
  end

  create_table "ip_hostnames", force: :cascade do |t|
    t.bigint "ip_address_id", null: false
    t.bigint "hostname_id", null: false
    t.index ["hostname_id"], name: "index_ip_hostnames_on_hostname_id"
    t.index ["ip_address_id"], name: "index_ip_hostnames_on_ip_address_id"
  end

  add_foreign_key "ip_hostnames", "hostnames"
  add_foreign_key "ip_hostnames", "ip_addresses"
end
