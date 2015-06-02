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

ActiveRecord::Schema.define(version: 20140723141023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "uid"
    t.string   "slug"
    t.integer  "owner_id"
    t.string   "stripe_account_id"
    t.string   "encrypted_stripe_secret_key"
    t.string   "encrypted_stripe_publishable_key"
    t.integer  "stripe_verification_status"
    t.string   "stripe_subscription_id"
    t.string   "stripe_subscription_status"
    t.string   "stripe_plan_id"
    t.string   "stripe_plan_name"
    t.string   "email"
    t.string   "country"
    t.string   "business_name"
    t.string   "business_url"
    t.string   "support_phone"
    t.string   "statement_descriptor"
    t.integer  "account_type",                     default: 0
    t.boolean  "current",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["country"], name: "index_accounts_on_country", using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", using: :btree
  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id", using: :btree
  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree
  add_index "accounts", ["stripe_account_id"], name: "index_accounts_on_stripe_account_id", using: :btree
  add_index "accounts", ["stripe_plan_id"], name: "index_accounts_on_stripe_plan_id", using: :btree
  add_index "accounts", ["stripe_subscription_id"], name: "index_accounts_on_stripe_subscription_id", using: :btree
  add_index "accounts", ["stripe_verification_status"], name: "index_accounts_on_stripe_verification_status", using: :btree
  add_index "accounts", ["uid"], name: "index_accounts_on_uid", unique: true, using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.integer  "permission"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["permission"], name: "index_admins_on_permission", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["uid"], name: "index_admins_on_uid", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "donations", force: :cascade do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.integer  "donor_id"
    t.integer  "fund_id"
    t.string   "stripe_id"
    t.boolean  "livemode"
    t.boolean  "paid"
    t.string   "status"
    t.string   "amount"
    t.string   "currency"
    t.boolean  "refunded"
    t.json     "source"
    t.boolean  "captured"
    t.string   "balance_transaction"
    t.string   "failure_message"
    t.string   "failure_code"
    t.integer  "amount_refunded"
    t.string   "customer"
    t.string   "invoice"
    t.text     "description"
    t.json     "dispute"
    t.json     "metadata"
    t.string   "statement_descriptor"
    t.json     "fraud_details"
    t.string   "receipt_email"
    t.string   "receipt_number"
    t.string   "destination"
    t.string   "application_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["currency"], name: "index_donations_on_currency", using: :btree
  add_index "donations", ["customer"], name: "index_donations_on_customer", using: :btree
  add_index "donations", ["destination"], name: "index_donations_on_destination", using: :btree
  add_index "donations", ["donor_id"], name: "index_donations_on_donor_id", using: :btree
  add_index "donations", ["fund_id"], name: "index_donations_on_fund_id", using: :btree
  add_index "donations", ["invoice"], name: "index_donations_on_invoice", using: :btree
  add_index "donations", ["paid"], name: "index_donations_on_paid", using: :btree
  add_index "donations", ["refunded"], name: "index_donations_on_refunded", using: :btree
  add_index "donations", ["status"], name: "index_donations_on_status", using: :btree
  add_index "donations", ["stripe_id"], name: "index_donations_on_stripe_id", using: :btree
  add_index "donations", ["uid"], name: "index_donations_on_uid", using: :btree
  add_index "donations", ["user_id"], name: "index_donations_on_user_id", using: :btree

  create_table "funds", force: :cascade do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "name"
    t.integer  "category"
    t.text     "description"
    t.date     "ends_at"
    t.integer  "goal"
    t.string   "slug"
    t.string   "statement_descriptor"
    t.string   "state"
    t.boolean  "org_contributions"
    t.string   "website"
    t.string   "street"
    t.string   "apt_suite"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.text     "reciept_message"
    t.string   "thank_you_reply_to"
    t.string   "thank_you_subject"
    t.text     "thank_you_body"
    t.string   "avatar"
    t.string   "header"
    t.string   "primary_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "funds", ["account_id"], name: "index_funds_on_account_id", using: :btree
  add_index "funds", ["slug"], name: "index_funds_on_slug", using: :btree
  add_index "funds", ["state"], name: "index_funds_on_state", using: :btree
  add_index "funds", ["uid"], name: "index_funds_on_uid", unique: true, using: :btree
  add_index "funds", ["user_id"], name: "index_funds_on_user_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.integer  "permission", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id"], name: "index_memberships_on_account_id", using: :btree
  add_index "memberships", ["permission"], name: "index_memberships_on_permission", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "metadata", force: :cascade do |t|
    t.string   "uid"
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "meta_type"
    t.integer  "meta_sub_type"
    t.string   "custom"
    t.date     "date"
    t.string   "street"
    t.string   "apt_suite"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "email_address"
    t.string   "number"
    t.string   "username"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadata", ["email_address"], name: "index_metadata_on_email_address", using: :btree
  add_index "metadata", ["meta_sub_type"], name: "index_metadata_on_meta_sub_type", using: :btree
  add_index "metadata", ["meta_type"], name: "index_metadata_on_meta_type", using: :btree
  add_index "metadata", ["number"], name: "index_metadata_on_number", using: :btree
  add_index "metadata", ["uid"], name: "index_metadata_on_uid", unique: true, using: :btree
  add_index "metadata", ["username"], name: "index_metadata_on_username", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.integer  "age"
    t.integer  "gender"
    t.string   "username"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.string   "stripe_default_source"
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["age"], name: "index_users_on_age", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
