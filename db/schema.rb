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

ActiveRecord::Schema.define(version: 20151205192835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.string   "nickname"
    t.string   "stripe_account_id"
    t.string   "stripe_bank_account_id"
    t.string   "stripe_bank_account_last4"
    t.string   "stripe_fingerprint"
    t.string   "country"
    t.string   "currency"
    t.boolean  "default_stripe_bank_account", default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "bank_accounts", ["country"], name: "index_bank_accounts_on_country", using: :btree
  add_index "bank_accounts", ["currency"], name: "index_bank_accounts_on_currency", using: :btree
  add_index "bank_accounts", ["default_stripe_bank_account"], name: "index_bank_accounts_on_default_stripe_bank_account", using: :btree
  add_index "bank_accounts", ["stripe_account_id"], name: "index_bank_accounts_on_stripe_account_id", using: :btree
  add_index "bank_accounts", ["stripe_bank_account_id"], name: "index_bank_accounts_on_stripe_bank_account_id", using: :btree
  add_index "bank_accounts", ["stripe_bank_account_last4"], name: "index_bank_accounts_on_stripe_bank_account_last4", using: :btree
  add_index "bank_accounts", ["stripe_fingerprint"], name: "index_bank_accounts_on_stripe_fingerprint", using: :btree
  add_index "bank_accounts", ["uid"], name: "index_bank_accounts_on_uid", unique: true, using: :btree
  add_index "bank_accounts", ["user_id"], name: "index_bank_accounts_on_user_id", using: :btree

  create_table "donations", force: :cascade do |t|
    t.string   "uid"
    t.integer  "recipient_id"
    t.integer  "donor_id"
    t.integer  "fund_id"
    t.integer  "designated_to"
    t.string   "currency",                     limit: 4
    t.integer  "amount_in_cents"
    t.integer  "stripe_fee_in_cents"
    t.integer  "onedonation_fee_in_cents"
    t.integer  "aggregated_fee_in_cents"
    t.integer  "amount_in_cents_usd"
    t.integer  "stripe_fee_in_cents_usd"
    t.integer  "onedonation_fee_in_cents_usd"
    t.integer  "aggregated_fee_in_cents_usd"
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.string   "stripe_source_id"
    t.string   "stripe_destination"
    t.string   "stripe_amount_refunded"
    t.string   "stripe_application_fee_id"
    t.jsonb    "stripe_balance_transaction",             default: {}, null: false
    t.string   "stripe_captured"
    t.string   "stripe_created"
    t.string   "stripe_currency"
    t.text     "stripe_description"
    t.jsonb    "stripe_dispute",                         default: {}
    t.string   "stripe_failure_code"
    t.string   "stripe_failure_message"
    t.jsonb    "stripe_fraud_details",                   default: {}
    t.jsonb    "stripe_metadata",                        default: {}
    t.string   "stripe_paid"
    t.string   "stripe_receipt_number"
    t.string   "stripe_refunded"
    t.jsonb    "stripe_refunds",                         default: {}
    t.jsonb    "stripe_source",                          default: {}, null: false
    t.string   "stripe_statement_descriptor"
    t.string   "stripe_status"
    t.text     "message"
    t.boolean  "anonymous"
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["aggregated_fee_in_cents"], name: "index_donations_on_aggregated_fee_in_cents", using: :btree
  add_index "donations", ["aggregated_fee_in_cents_usd"], name: "index_donations_on_aggregated_fee_in_cents_usd", using: :btree
  add_index "donations", ["amount_in_cents"], name: "index_donations_on_amount_in_cents", using: :btree
  add_index "donations", ["amount_in_cents_usd"], name: "index_donations_on_amount_in_cents_usd", using: :btree
  add_index "donations", ["anonymous"], name: "index_donations_on_anonymous", using: :btree
  add_index "donations", ["currency"], name: "index_donations_on_currency", using: :btree
  add_index "donations", ["designated_to"], name: "index_donations_on_designated_to", using: :btree
  add_index "donations", ["donor_id"], name: "index_donations_on_donor_id", using: :btree
  add_index "donations", ["fund_id"], name: "index_donations_on_fund_id", using: :btree
  add_index "donations", ["onedonation_fee_in_cents"], name: "index_donations_on_onedonation_fee_in_cents", using: :btree
  add_index "donations", ["onedonation_fee_in_cents_usd"], name: "index_donations_on_onedonation_fee_in_cents_usd", using: :btree
  add_index "donations", ["recipient_id"], name: "index_donations_on_recipient_id", using: :btree
  add_index "donations", ["remote_ip"], name: "index_donations_on_remote_ip", using: :btree
  add_index "donations", ["stripe_amount_refunded"], name: "index_donations_on_stripe_amount_refunded", using: :btree
  add_index "donations", ["stripe_application_fee_id"], name: "index_donations_on_stripe_application_fee_id", using: :btree
  add_index "donations", ["stripe_balance_transaction"], name: "index_donations_on_stripe_balance_transaction", using: :gin
  add_index "donations", ["stripe_captured"], name: "index_donations_on_stripe_captured", using: :btree
  add_index "donations", ["stripe_charge_id"], name: "index_donations_on_stripe_charge_id", using: :btree
  add_index "donations", ["stripe_created"], name: "index_donations_on_stripe_created", using: :btree
  add_index "donations", ["stripe_currency"], name: "index_donations_on_stripe_currency", using: :btree
  add_index "donations", ["stripe_customer_id"], name: "index_donations_on_stripe_customer_id", using: :btree
  add_index "donations", ["stripe_destination"], name: "index_donations_on_stripe_destination", using: :btree
  add_index "donations", ["stripe_dispute"], name: "index_donations_on_stripe_dispute", using: :gin
  add_index "donations", ["stripe_failure_code"], name: "index_donations_on_stripe_failure_code", using: :btree
  add_index "donations", ["stripe_fee_in_cents"], name: "index_donations_on_stripe_fee_in_cents", using: :btree
  add_index "donations", ["stripe_fee_in_cents_usd"], name: "index_donations_on_stripe_fee_in_cents_usd", using: :btree
  add_index "donations", ["stripe_fraud_details"], name: "index_donations_on_stripe_fraud_details", using: :gin
  add_index "donations", ["stripe_metadata"], name: "index_donations_on_stripe_metadata", using: :gin
  add_index "donations", ["stripe_paid"], name: "index_donations_on_stripe_paid", using: :btree
  add_index "donations", ["stripe_receipt_number"], name: "index_donations_on_stripe_receipt_number", using: :btree
  add_index "donations", ["stripe_refunded"], name: "index_donations_on_stripe_refunded", using: :btree
  add_index "donations", ["stripe_refunds"], name: "index_donations_on_stripe_refunds", using: :gin
  add_index "donations", ["stripe_source"], name: "index_donations_on_stripe_source", using: :gin
  add_index "donations", ["stripe_source_id"], name: "index_donations_on_stripe_source_id", using: :btree
  add_index "donations", ["stripe_statement_descriptor"], name: "index_donations_on_stripe_statement_descriptor", using: :btree
  add_index "donations", ["stripe_status"], name: "index_donations_on_stripe_status", using: :btree
  add_index "donations", ["uid"], name: "index_donations_on_uid", using: :btree

  create_table "funds", force: :cascade do |t|
    t.string   "uid"
    t.integer  "owner_id"
    t.boolean  "group_fund",                  default: false
    t.string   "name"
    t.string   "url"
    t.integer  "category",                    default: 0,     null: false
    t.integer  "status",                      default: 0,     null: false
    t.date     "ends_at"
    t.integer  "goal"
    t.string   "custom_statement_descriptor"
    t.text     "description"
    t.string   "website"
    t.text     "receipt_message"
    t.string   "thank_you_reply_to"
    t.string   "thank_you_header"
    t.text     "thank_you_body"
    t.string   "thumbnail"
    t.string   "header"
    t.string   "primary_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "funds", ["owner_id"], name: "index_funds_on_owner_id", using: :btree
  add_index "funds", ["status"], name: "index_funds_on_status", using: :btree
  add_index "funds", ["uid"], name: "index_funds_on_uid", unique: true, using: :btree
  add_index "funds", ["url"], name: "index_funds_on_url", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "fund_id"
    t.integer  "permission", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["fund_id"], name: "index_memberships_on_fund_id", using: :btree
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
    t.string   "line1"
    t.string   "line2"
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
    t.string   "username"
    t.string   "email",                            default: "", null: false
    t.string   "stripe_customer_id"
    t.string   "stripe_account_id"
    t.string   "stripe_default_source"
    t.string   "stripe_statement_descriptor"
    t.jsonb    "stripe_tos_acceptance",            default: {}, null: false
    t.jsonb    "stripe_legal_entity",              default: {}, null: false
    t.jsonb    "stripe_verification",              default: {}, null: false
    t.integer  "stripe_verification_status"
    t.string   "stripe_currency"
    t.string   "encrypted_stripe_secret_key"
    t.string   "encrypted_stripe_publishable_key"
    t.integer  "status",                           default: 0,  null: false
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.integer  "age"
    t.integer  "gender"
    t.integer  "entity_type"
    t.string   "business_name"
    t.string   "business_url"
    t.string   "encrypted_business_tax_id"
    t.string   "encrypted_business_vat_id"
    t.string   "business_line1"
    t.string   "business_line2"
    t.string   "business_city"
    t.string   "business_state"
    t.string   "business_postal_code"
    t.string   "business_country"
    t.string   "user_phone"
    t.string   "user_line1"
    t.string   "user_line2"
    t.string   "user_city"
    t.string   "user_state"
    t.string   "user_postal_code"
    t.string   "user_country"
    t.string   "encrypted_ssn_last_4"
    t.string   "dob_month"
    t.string   "dob_day"
    t.string   "dob_year"
    t.string   "timezone"
    t.integer  "account_type",                     default: 0
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                  default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_type"], name: "index_users_on_account_type", using: :btree
  add_index "users", ["age"], name: "index_users_on_age", using: :btree
  add_index "users", ["business_country"], name: "index_users_on_business_country", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["status"], name: "index_users_on_status", using: :btree
  add_index "users", ["stripe_account_id"], name: "index_users_on_stripe_account_id", using: :btree
  add_index "users", ["stripe_currency"], name: "index_users_on_stripe_currency", using: :btree
  add_index "users", ["stripe_legal_entity"], name: "index_users_on_stripe_legal_entity", using: :gin
  add_index "users", ["stripe_tos_acceptance"], name: "index_users_on_stripe_tos_acceptance", using: :gin
  add_index "users", ["stripe_verification"], name: "index_users_on_stripe_verification", using: :gin
  add_index "users", ["stripe_verification_status"], name: "index_users_on_stripe_verification_status", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["user_country"], name: "index_users_on_user_country", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
